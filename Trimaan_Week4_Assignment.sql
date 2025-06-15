CREATE DATABASE ElectiveAllotmentDB;
GO

USE ElectiveAllotmentDB;
GO


-- StudentDetails Table
CREATE TABLE StudentDetails (
    StudentId INT PRIMARY KEY,
    StudentName VARCHAR(100),
    GPA FLOAT,
    Branch VARCHAR(10),
    Section CHAR(1)
);

-- SubjectDetails Table
CREATE TABLE SubjectDetails (
    SubjectId VARCHAR(10) PRIMARY KEY,
    SubjectName VARCHAR(100),
    MaxSeats INT,
    RemainingSeats INT
);

-- StudentPreference Table
CREATE TABLE StudentPreference (
    StudentId INT,
    SubjectId VARCHAR(10),
    Preference INT CHECK (Preference BETWEEN 1 AND 5),
    PRIMARY KEY (StudentId, Preference),
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);

-- Allotments Table
CREATE TABLE Allotments (
    SubjectId VARCHAR(10),
    StudentId INT,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId),
    FOREIGN KEY (SubjectId) REFERENCES SubjectDetails(SubjectId)
);

-- UnallotedStudents Table
CREATE TABLE UnallotedStudents (
    StudentId INT PRIMARY KEY,
    FOREIGN KEY (StudentId) REFERENCES StudentDetails(StudentId)
);

-- Insert Sample Data

-- Subjects
INSERT INTO SubjectDetails VALUES
('PO1491', 'Basics of Political Science', 60, 2),
('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);

-- Students
INSERT INTO StudentDetails VALUES
(159103036, 'Mohit Agarwal', 8.9, 'CCE', 'A'),
(159103037, 'Rohit Agarwal', 5.2, 'CCE', 'A'),
(159103038, 'Shohit Garg', 7.1, 'CCE', 'B'),
(159103039, 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
(159103040, 'Mehreet Singh', 5.6, 'CCE', 'A'),
(159103041, 'Arjun Tehlan', 9.2, 'CCE', 'B');

-- Student Preferences
-- Mohit
INSERT INTO StudentPreference VALUES
(159103036, 'PO1491', 1),
(159103036, 'PO1492', 2),
(159103036, 'PO1493', 3),
(159103036, 'PO1494', 4),
(159103036, 'PO1495', 5);
-- Rohit
INSERT INTO StudentPreference VALUES
(159103037, 'PO1491', 1),
(159103037, 'PO1492', 2),
(159103037, 'PO1493', 3),
(159103037, 'PO1494', 4),
(159103037, 'PO1495', 5);
-- Shohit
INSERT INTO StudentPreference VALUES
(159103038, 'PO1492', 1),
(159103038, 'PO1493', 2),
(159103038, 'PO1494', 3),
(159103038, 'PO1491', 4),
(159103038, 'PO1495', 5);
-- Mrinal
INSERT INTO StudentPreference VALUES
(159103039, 'PO1491', 1),
(159103039, 'PO1492', 2),
(159103039, 'PO1493', 3),
(159103039, 'PO1494', 4),
(159103039, 'PO1495', 5);
-- Mehreet
INSERT INTO StudentPreference VALUES
(159103040, 'PO1493', 1),
(159103040, 'PO1492', 2),
(159103040, 'PO1495', 3),
(159103040, 'PO1494', 4),
(159103040, 'PO1491', 5);
-- Arjun
INSERT INTO StudentPreference VALUES
(159103041, 'PO1491', 1),
(159103041, 'PO1492', 2),
(159103041, 'PO1493', 3),
(159103041, 'PO1494', 4),
(159103041, 'PO1495', 5);

-- Stored Procedure to allocate Open Elective Subjects to students based on GPA and preferences
CREATE PROCEDURE AllocateSubjects
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables for processing
    DECLARE @StudentId INT, @SubjectId VARCHAR(10), @Preference INT, @GPA DECIMAL(3,1);
    DECLARE @RemainingSeats INT, @StudentName VARCHAR(100);

    -- Cursor to iterate through students ordered by GPA (descending) for priority allocation
    DECLARE student_cursor CURSOR FOR
        SELECT s.StudentId, s.StudentName, s.GPA
        FROM StudentDetails s
        ORDER BY s.GPA DESC;

    -- Begin transaction to ensure data consistency
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Clear previous allotments and unallotted records for fresh allocation
        DELETE FROM Allotments;
        DELETE FROM UnallotedStudents;

        -- Open cursor and process each student
        OPEN student_cursor;
        FETCH NEXT FROM student_cursor INTO @StudentId, @StudentName, @GPA;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            DECLARE @Allotted BIT = 0; -- Flag to track if student is allotted a subject

            -- Cursor for student's preferences (1 to 5)
            DECLARE preference_cursor CURSOR FOR
                SELECT sp.SubjectId, sp.Preference
                FROM StudentPreference sp
                WHERE sp.StudentId = @StudentId
                ORDER BY sp.Preference ASC;

            -- Open preference cursor
            OPEN preference_cursor;
            FETCH NEXT FROM preference_cursor INTO @SubjectId, @Preference;

            WHILE @@FETCH_STATUS = 0 AND @Allotted = 0
            BEGIN
                -- Check remaining seats for the subject
                SELECT @RemainingSeats = RemainingSeats
                FROM SubjectDetails
                WHERE SubjectId = @SubjectId;

                -- If seats are available, allocate the subject
                IF @RemainingSeats > 0
                BEGIN
                    -- Insert into Allotments table
                    INSERT INTO Allotments (SubjectId, StudentId)
                    VALUES (@SubjectId, @StudentId);

                    -- Update remaining seats in SubjectDetails
                    UPDATE SubjectDetails
                    SET RemainingSeats = RemainingSeats - 1
                    WHERE SubjectId = @SubjectId;

                    SET @Allotted = 1; -- Mark as allotted
                END

                -- Fetch next preference
                FETCH NEXT FROM preference_cursor INTO @SubjectId, @Preference;
            END

            -- Close and deallocate preference cursor
            CLOSE preference_cursor;
            DEALLOCATE preference_cursor;

            -- If no subject was allotted, mark student as unallotted
            IF @Allotted = 0
            BEGIN
                INSERT INTO UnallotedStudents (StudentId)
                VALUES (@StudentId);
            END

            -- Fetch next student
            FETCH NEXT FROM student_cursor INTO @StudentId, @StudentName, @GPA;
        END

        -- Close and deallocate student cursor
        CLOSE student_cursor;
        DEALLOCATE student_cursor;

        -- Commit transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback transaction on error
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Raise error with details
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END;
GO
SELECT * FROM Allotments;

SELECT * FROM UnallotedStudents;

SELECT * FROM SubjectDetails;