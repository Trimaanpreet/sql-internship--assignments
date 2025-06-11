USE AdventureWorks2019;
GO

IF OBJECT_ID('dbo.InsertOrderDetails','P') IS NOT NULL
    DROP PROCEDURE dbo.InsertOrderDetails;
GO

CREATE PROCEDURE dbo.InsertOrderDetails
    @OrderID     INT,
    @ProductID   INT,
    @Quantity    SMALLINT,
    @UnitPrice   MONEY = NULL,      -- optional
    @Discount    FLOAT = 0          -- optional
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE 
        @invQty        INT,           -- current on-hand
        @defaultPrice  MONEY,
        @locationID    INT;

    SET @locationID = 1;  -- use default location

    -- 1. Pull inventory & default price
    SELECT TOP(1)
        @invQty = pi.Quantity,
        @defaultPrice = p.ListPrice
    FROM Production.ProductInventory pi
    JOIN Production.Product p ON p.ProductID = pi.ProductID
    WHERE pi.ProductID = @ProductID
      AND pi.LocationID = @locationID;

    IF @invQty IS NULL
    BEGIN
        PRINT N'Invalid ProductID – no inventory row.';
        RETURN;
    END

    -- 2. Check stock
    IF @Quantity > @invQty
    BEGIN
        PRINT N'Insufficient stock – order aborted.';
        RETURN;
    END

    -- 3. Default UnitPrice if not given
    IF @UnitPrice IS NULL
        SET @UnitPrice = @defaultPrice;

    BEGIN TRY
        BEGIN TRAN;

        DECLARE @rc INT;

        INSERT INTO Sales.SalesOrderDetail
            (SalesOrderID, ProductID, OrderQty, UnitPrice, UnitPriceDiscount)
        VALUES
            (@OrderID, @ProductID, @Quantity, @UnitPrice, @Discount);

        SET @rc = @@ROWCOUNT;

        IF @rc = 0
        BEGIN
            PRINT N'Failed to place the order. Please try again.';
            ROLLBACK;
            RETURN;
        END

        -- 4. Decrement inventory
        UPDATE Production.ProductInventory
        SET Quantity = Quantity - @Quantity
        WHERE ProductID = @ProductID AND LocationID = @locationID;

        -- 5. Low-stock warning
        SELECT @invQty = Quantity
        FROM Production.ProductInventory
        WHERE ProductID = @ProductID AND LocationID = @locationID;

        IF EXISTS (
            SELECT 1 FROM Production.Product p
            WHERE p.ProductID = @ProductID AND @invQty < p.ReorderPoint
        )
        BEGIN
            PRINT N'Warning – stock dropped below ReorderPoint.';
        END

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO

IF OBJECT_ID('dbo.UpdateOrderDetails','P') IS NOT NULL
    DROP PROCEDURE dbo.UpdateOrderDetails;
GO

CREATE PROCEDURE dbo.UpdateOrderDetails
      @OrderID   INT
    , @ProductID INT
    , @UnitPrice MONEY     = NULL
    , @Quantity  SMALLINT  = NULL
    , @Discount  FLOAT     = NULL
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @oldQty SMALLINT, @deltaQty INT;

    BEGIN TRY
        BEGIN TRAN;

        -- Get original order quantity
        SELECT @oldQty = OrderQty
        FROM   Sales.SalesOrderDetail
        WHERE  SalesOrderID = @OrderID
          AND  ProductID    = @ProductID;

        IF @oldQty IS NULL
        BEGIN
            PRINT N'Order/Product combination not found.';
            ROLLBACK;
            RETURN;
        END

        -- Update order details with new values or keep old if NULL
        UPDATE Sales.SalesOrderDetail
        SET
              OrderQty          = ISNULL(@Quantity, OrderQty),
              UnitPrice         = ISNULL(@UnitPrice, UnitPrice),
              UnitPriceDiscount = ISNULL(@Discount, UnitPriceDiscount)
        WHERE  SalesOrderID = @OrderID
          AND  ProductID    = @ProductID;

        -- Update inventory if quantity changed
        IF @Quantity IS NOT NULL
        BEGIN
            SET @deltaQty = @Quantity - @oldQty;

            UPDATE Production.ProductInventory
            SET    Quantity = Quantity - @deltaQty
            WHERE  ProductID  = @ProductID
              AND  LocationID = 1;
        END;

        COMMIT;
    END TRY
    BEGIN CATCH
        IF XACT_STATE() <> 0 ROLLBACK;
        THROW;
    END CATCH
END;
GO


IF OBJECT_ID('dbo.GetOrderDetails','P') IS NOT NULL
    DROP PROCEDURE dbo.GetOrderDetails;
GO

CREATE PROCEDURE dbo.GetOrderDetails
      @OrderID INT
AS
BEGIN
    IF NOT EXISTS (
        SELECT 1
        FROM   Sales.SalesOrderDetail
        WHERE  SalesOrderID = @OrderID
    )
    BEGIN
        PRINT N'The OrderID ' + CAST(@OrderID AS VARCHAR(10)) + N' does not exist';
        RETURN 1;
    END;

    SELECT *
    FROM   Sales.SalesOrderDetail
    WHERE  SalesOrderID = @OrderID;
END;
GO


IF OBJECT_ID('dbo.DeleteOrderDetails','P') IS NOT NULL DROP PROCEDURE dbo.DeleteOrderDetails;
GO
CREATE PROCEDURE dbo.DeleteOrderDetails
      @OrderID   INT,
      @ProductID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the OrderID and ProductID combination exists
    IF NOT EXISTS (
        SELECT 1 FROM Sales.SalesOrderDetail
        WHERE SalesOrderID = @OrderID AND ProductID = @ProductID
    )
    BEGIN
        PRINT N'Invalid combination – nothing deleted.';
        RETURN -1;  -- error code for invalid parameters
    END;

    -- Delete the record
    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    PRINT N'Order detail successfully removed.';
END;
GO


-- Function 1: Format date as MM/DD/YYYY
IF OBJECT_ID('dbo.fn_Format_MMDDYYYY','FN') IS NOT NULL DROP FUNCTION dbo.fn_Format_MMDDYYYY;
GO
CREATE FUNCTION dbo.fn_Format_MMDDYYYY (@d DATETIME)
RETURNS CHAR(10) WITH SCHEMABINDING
AS
BEGIN
    RETURN CONVERT(CHAR(10), @d, 101);   -- 101 = mm/dd/yyyy format
END;
GO

      /* VIEWS */

-- View 1: vwCustomerOrders - full orders info
IF OBJECT_ID('dbo.vwCustomerOrders','V') IS NOT NULL DROP VIEW dbo.vwCustomerOrders;
GO
CREATE VIEW dbo.vwCustomerOrders AS
SELECT
      s.Name                         AS CompanyName
    , soh.SalesOrderID               AS OrderID
    , soh.OrderDate
    , sod.ProductID
    , p.Name                         AS ProductName
    , sod.OrderQty                   AS Quantity
    , sod.UnitPrice
    , sod.LineTotal
FROM Sales.SalesOrderHeader  AS soh
JOIN Sales.SalesOrderDetail  AS sod ON sod.SalesOrderID = soh.SalesOrderID
JOIN Production.Product      AS p   ON p.ProductID      = sod.ProductID
JOIN Sales.Customer          AS c   ON c.CustomerID     = soh.CustomerID
JOIN Sales.Store             AS s   ON s.BusinessEntityID = c.StoreID;
GO

-- View 2: vwCustomerOrders_Yesterday - orders placed yesterday only
IF OBJECT_ID('dbo.vwCustomerOrders_Yesterday','V') IS NOT NULL DROP VIEW dbo.vwCustomerOrders_Yesterday;
GO
CREATE VIEW dbo.vwCustomerOrders_Yesterday AS
SELECT * FROM dbo.vwCustomerOrders
WHERE CAST(OrderDate AS DATE) = CAST(DATEADD(DAY,-1,GETDATE()) AS DATE);
GO

-- View 3: MyProducts - active products with supplier & category info
IF OBJECT_ID('dbo.MyProducts','V') IS NOT NULL DROP VIEW dbo.MyProducts;
GO
CREATE VIEW dbo.MyProducts AS
SELECT
      p.ProductID
    , p.Name                           AS ProductName
    , p.Size                           AS QuantityPerUnit
    , p.ListPrice                      AS UnitPrice
    , v.Name                           AS SupplierName
    , pc.Name                          AS CategoryName
FROM Production.Product             p
JOIN Production.ProductSubcategory  sc  ON sc.ProductSubcategoryID = p.ProductSubcategoryID
JOIN Production.ProductCategory     pc  ON pc.ProductCategoryID    = sc.ProductCategoryID
JOIN Purchasing.ProductVendor       pv  ON pv.ProductID            = p.ProductID
JOIN Purchasing.Vendor              v   ON v.BusinessEntityID      = pv.BusinessEntityID
WHERE p.DiscontinuedDate IS NULL;
GO

       /* TRIGGERS */

IF OBJECT_ID('Sales.trg_Orders_CascadeDelete','TR') IS NOT NULL DROP TRIGGER Sales.trg_Orders_CascadeDelete;
GO
CREATE TRIGGER Sales.trg_Orders_CascadeDelete
ON Sales.SalesOrderHeader
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DELETE sod
    FROM Sales.SalesOrderDetail sod
    INNER JOIN deleted d ON d.SalesOrderID = sod.SalesOrderID;

    DELETE soh
    FROM Sales.SalesOrderHeader soh
    INNER JOIN deleted d ON d.SalesOrderID = soh.SalesOrderID;
END;
GO


IF OBJECT_ID('Sales.trg_OrderDetail_StockCheck','TR') IS NOT NULL DROP TRIGGER Sales.trg_OrderDetail_StockCheck;
GO
CREATE TRIGGER Sales.trg_OrderDetail_StockCheck
ON Sales.SalesOrderDetail
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @bad INT = 0;

    ;WITH x AS (
        SELECT i.ProductID, SUM(i.OrderQty) AS NewQty
        FROM inserted i
        GROUP BY i.ProductID
    )
    SELECT TOP 1 @bad = 1
    FROM x
    JOIN Production.ProductInventory pi ON pi.ProductID = x.ProductID AND pi.LocationID = 1
    WHERE x.NewQty > pi.Quantity;

    IF @bad = 1
    BEGIN
        RAISERROR ('Insufficient stock – order rejected.', 16, 1);
        ROLLBACK;
        RETURN;
    END;

    /* subtract qty */
    UPDATE pi
    SET Quantity = Quantity - x.NewQty
    FROM Production.ProductInventory pi
    JOIN x ON x.ProductID = pi.ProductID
    WHERE pi.LocationID = 1;
END;
GO

