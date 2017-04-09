<cfcomponent>

    <!--- getst the Orders from the Order Table for the User --->
    <cffunction name="getOrders" access="remote" returntype="query" >

        <cfquery name="REQUEST.Orders">
            SELECT o.OrderId --, o.SubTotal, o.OrderDate, o.PaymentMethod, o.Status--, od.OrderQty, od.ProductId, od.SupplierId
            from [Order] o
            <!--- INNER JOIN [OrderDetails] od --->
            <!--- ON o.OrderId = od.OrderId --->
            WHERE o.UserId = #SESSION.User.UserId#
        </cfquery>

        <cfreturn REQUEST.Orders />
    </cffunction>

    <cffunction name="getOrderDetails" access="remote" returntype="query" >
        <cfargument name="OrderId" type="numeric" required = "true" />

        <cfquery name="REQUEST.orderDetails">
            SELECT o.OrderId , o.SubTotal, o.OrderDate, o.PaymentMethod, o.Status, od.OrderQty, od.ProductId, od.SupplierId, od.ShipToAddressId, a.AddressLine, a.PhoneNo
            from [Order] o
                INNER JOIN [OrderDetails] od
                ON o.OrderId = od.OrderId
                    INNER JOIN [Address] a
                    ON od.ShipToAddressId = a.AddressId
            WHERE od.OrderId = #ARGUMENTS.OrderId#  
        </cfquery>

        <cfreturn REQUEST.orderDetails />
    </cffunction>


</cfcomponent>
