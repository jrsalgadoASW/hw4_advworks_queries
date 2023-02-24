/*
Listar el top 10 de productos mas 
caros vendidos por territorio en el ultimo mes.
*/

/*
Necesito todos los productos vendidos por territorio, y fecha de venta

SalesOrderHeader:
    * TerritoryID (territorio de la compra)
    * SalesOrderID (FK a detalles de la compra)
    * OrderDate
SalesOrderDetailID:
    * ProductID: id del producto
    * UnitPrice: Precio de un solo producto. De lo que se observó, 
                solo hay un tipo de producto por venta.
*/
DECLARE @lastMonthEnd DATE;
SET @lastMonthEnd = '2014-06-30';
DECLARE @lastMonthBegin DATE;
SET @lastMonthBegin = '2014-06-01';

WITH

    ProductsSoldByTerritoryInLastMonth
    AS

    (
        SELECT
            orderHeader.TerritoryID,
            orderDetails.ProductID AS ProductID,
            orderDetails.UnitPrice as UnitPrice,
            ROW_NUMBER() OVER(PARTITION BY TerritoryID ORDER BY UnitPrice DESC) ranking
        FROM Sales.SalesOrderHeader orderHeader
            INNER JOIN Sales.SalesOrderDetail orderDetails ON orderDetails.SalesOrderID = orderHeader.SalesOrderID
        WHERE orderHeader.OrderDate >= DATEADD(
            month, -1, (
                SELECT MAX(OrderDate)
                FROM Sales.SalesOrderHeader)
            )

    )
SELECT *
FROM ProductsSoldByTerritoryInLastMonth
WHERE ranking<11;
