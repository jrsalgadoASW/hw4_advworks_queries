/*
Listar el top 10 de productos mas vendidos por territorio en el ultimo mes.
*/

/*
Necesito crear el count a partir de SalesOrderHeader

SalesOrderHeader:
    * TerritoryID (territorio de la compra)
    * SalesOrderID (FK a detalles de la compra)
    * OrderDate
SalesOrderDetailID:
    * ProductID: id del producto
*/

DECLARE @lastMonthEnd DATE;
SET @lastMonthEnd = '2014-06-30';
DECLARE @lastMonthBegin DATE;
SET @lastMonthBegin = '2014-06-01';


WITH

    ProductsCountInTerritoryInLastMonth
    AS

    (
        SELECT
            orderHeader.TerritoryID,
            orderDetails.ProductID AS ProductID,
            COUNT(ProductID) SalesCount,
            ROW_NUMBER() OVER(PARTITION BY TerritoryID ORDER BY COUNT(ProductID) DESC) ranking
        FROM Sales.SalesOrderHeader orderHeader
            INNER JOIN Sales.SalesOrderDetail orderDetails ON orderDetails.SalesOrderID = orderHeader.SalesOrderID
        WHERE orderHeader.OrderDate >= DATEADD(
            month, -1, (
                SELECT MAX(OrderDate)
                FROM Sales.SalesOrderHeader)
            )
        GROUP BY TerritoryID, ProductID 

    )
SELECT *
FROM ProductsCountInTerritoryInLastMonth
WHERE ranking<11;
