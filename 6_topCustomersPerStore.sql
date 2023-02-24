/*
Listar los 5 clientes con las compras mas altas para cada mes en el año mas reciente, para cada tienda.
*/

/*
Necesito los clientes de cada tienda,
y el total a pagar de cada customer. 
*/
WITH
    -- Todas las ventas del año pasado
    LastYearSales
    AS

    (
        SELECT TotalDue, CustomerID, OrderDate
        FROM Sales.SalesOrderHeader orderHeader
        WHERE orderHeader.OrderDate >= DATEADD(
        YEAR, -1, (
            SELECT MAX(OrderDate)
        FROM Sales.SalesOrderHeader)
        )
    ),
    -- Información de cual customer compra en cual tienda
    CustomerStores
    AS

    (

        SELECT customer.StoreID AS StoreID,
            customer.CustomerID AS CustomerID
        FROM Sales.Customer customer
        WHERE StoreID IS NOT NULL AND customer.CustomerID IS NOT NULL
    ),
    -- Join de las dos anteriores
    SalesPerCustomerPerStore
    AS
    
    (
        SELECT CustomerStores.CustomerID, TotalDue, StoreID
        FROM CustomerStores
            INNER JOIN LastYearSales ON LastYearSales.CustomerID = CustomerStores.CustomerID
    ),
    SumCustomerPurchases AS (
        SELECT StoreID, CustomerID, SUM(TotalDue) as SumTotalDue
        FROM SalesPerCustomerPerStore
        GROUP BY StoreID, CustomerID
    ),
    CustomerSalesRankingWithinStore AS(
 SELECT StoreID, CustomerID, SumTotalDue,
    ROW_NUMBER() OVER (PARTITION BY storeid, customerid ORDER BY SumTotalDue DESC) AS ranking
  FROM SumCustomerPurchases
    )
-- Top 5 de clientes en cada tienda (los que hicieron las compras mas grandes, no la suma de las compras individuales)
SELECT
    *
FROM CustomerSalesRankingWithinStore
WHERE ranking <= 5
ORDER BY StoreID, SumTotalDue DESC;