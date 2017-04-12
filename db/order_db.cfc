<cfcomponent>


<!---
    returns query containing the order details for showing in the order deatils page ..
    returns to the "orderDetails" variable in the orders page.
--->
    <cffunction name="getOrderDetails" returntype="Query" access="public"  >
        <cfargument name="OrderId" required = "true" type="numeric" />

        <cfquery name="LOCAL.orderDetails">
            SELECT o.OrderId , o.SubTotal, o.OrderDate, o.PaymentMethod, o.Status,
                   od.OrderQty, od.ProductId, od.SupplierId, od.ShipToAddressId,
                   a.AddressLine, a.PhoneNo,
                   p.Image

            from [Order] o

                INNER JOIN [OrderDetails] od
                ON o.OrderId = od.OrderId

                    INNER JOIN [Address] a
                    ON od.ShipToAddressId = a.AddressId

                        INNER JOIN [Product] p
                        ON p.ProductId = od.ProductId

            WHERE od.OrderId = #ARGUMENTS.OrderId#
        </cfquery>

        <cfreturn LOCAL.orderDetails />
    </cffunction>


</cfcomponent>
