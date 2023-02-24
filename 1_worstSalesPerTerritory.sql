--* Cual es el top 3 de tiendas con la cuota de venta promedio mas baja por cada territorio.
/*
Necesito la información de las ventas, las tiendas y los territorios.
SalesTerritory: Información del territorio.
Stores: Tiene la información de la tienda, y el ID del SalesPerson
Customer: Tiene el ID de la tienda y del territorio. 
SalesOrderHeader: Tiene la información del customer y de las ventas

*/



WITH
    SalesAverage
    AS
    (
        SELECT
            territory.TerritoryID,
            store.BusinessEntityID AS StoreID,
            AVG(salesOrderHeader.SubTotal) AS AverageSales
        FROM
            Sales.SalesOrderHeader AS salesOrderHeader
            -- venta a cada customer
            JOIN Sales.Customer AS customer ON salesOrderHeader.CustomerID = customer.CustomerID
            -- tienda de cada customer
            JOIN Sales.Store AS store ON customer.StoreID = store.BusinessEntityID
            -- territorio de cada customer. Por el diagrama, se asume que el territorio del customer es el mismo del de la tienda.
            JOIN Sales.SalesTerritory AS territory ON customer.TerritoryID = territory.TerritoryID
        GROUP BY
        territory.TerritoryID,
        store.BusinessEntityID
    )
SELECT
    SA.TerritoryID,
    SA.StoreID,
    SA.AverageSales
FROM
    SalesAverage AS SA

-- TODO: Hacer el ranking por territorio 