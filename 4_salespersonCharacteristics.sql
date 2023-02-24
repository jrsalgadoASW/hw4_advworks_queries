/*
Construir una consulta en donde se muestre para cada tienda las siguientes caracteristicas:
    * el numero de vendedores de cada tienda
    * la cuota  de venta
    * bonus mas alto en la tienda 
    * el promedio de porcentaje de comision x tienda. 
(Hint la cuota esta en  [Sales].[Store] )

Hola Johnatan, Si lees este comentario es para que sepas que 
no pude encontrar que es la cuota de la tienda, solo del vendedor, 
porque una tienda solo tiene un vendedor 
pero un vendedor puede estar en varias tiendas.
Además, no estoy 100% que es una cuota, porque hay un 
campo llamado cuota pero también se podría referir a
las ganancias de cada tienda? Y el campo bonus solo se menciona 
de manera individual por cada vendedor.
De cualquier forma, por eso me tomé el atrevimiento de cambiar el ejercicio por el siguiente: 

Construir una consulta en donde se muestre para cada tienda las siguientes caracteristicas:
    * el numero de tiendas por cada vendedor
    * Cuota de cada vendedor
    * bonus mas alto para cada vendedor
    * el promedio de porcentaje de comision x vendedor. 

    *Total de ganancias si la comision se cumple la cuota (%comision * cuota + bono )
    *Ganancias promedio del vendedor por tienda (ganancias totales / numero de tiendas)
*/

/*
Necesito el count de tienda por vendedor

Sales.Store: 
    * SalesPersonId
    * StoreID (BusinessEntityID)
*/
WITH
    StorePerSalesPersonCount
    AS
    (
        SELECT store.SalesPersonID as SalesPersonId ,
            COUNT(store.BusinessEntityID) as StoreCount
        FROM Sales.Store store
        GROUP BY store.SalesPersonID
    ),
    SalesPersonQuota
    AS
    (
        SELECT salesPerson.BusinessEntityID AS SalesPersonID , 
                salesPerson.SalesQuota AS Quota,
                salesPerson.Bonus AS Bonus, 
                salesPerson.CommissionPct AS Commision
        FROM Sales.SalesPerson AS salesPerson
    )
SELECT (Quota*Commision+Bonus) AS ExpectedEarnings, ((Quota*Commision+Bonus)/StoreCount) AS EarningsPerStore,* 
FROM SalesPersonQuota 
    INNER JOIN StorePerSalesPersonCount ON StorePerSalesPersonCount.SalesPersonId = SalesPersonQuota.SalesPersonID
ORDER BY Commision ASC ,EarningsPerStore DESC; 
