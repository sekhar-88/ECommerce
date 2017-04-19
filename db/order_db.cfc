<cfcomponent>


<!---
    returns query containing the order details for showing in the order deatils page ..
    returns to the "orderDetails" variable in the orders page.
--->
    <cffunction name="getOrderDetails" returntype="Query" access="public"  >
        <cfargument name="OrderId" required = "true" type="numeric" />

        <cfquery name="LOCAL.orderDetails" cachedwithin="#CreateTimeSpan(0,0,10,0)#" >
            SELECT o.OrderId , o.SubTotal, o.OrderDate, o.PaymentMethod, o.Status,
                   od.OrderQty, od.UnitPrice, od.ProductId, od.SupplierId, od.ShipToAddressId,
                   a.Name AS PersonName , a.AddressLine, a.PhoneNo, a.PostalCode,
                   p.Image, p.Name AS ProductName, p.Description

            FROM [OrderDetails] od

                INNER JOIN [Order] o
                ON o.OrderId = od.OrderId

                    INNER JOIN [Address] a
                    ON od.ShipToAddressId = a.AddressId

                        INNER JOIN [Product] p
                        ON p.ProductId = od.ProductId

            WHERE od.OrderId = #ARGUMENTS.OrderId#
        </cfquery>

        <cfreturn LOCAL.orderDetails />
    </cffunction>


<!---
    returns query containing no. of orders, with details
--->
    <cffunction name="getOrdersFromDB" returntype= "Query" access = "public" >
        <cftry >

            <cfquery name="LOCAL.Orders">
                SELECT o.OrderId, o.SubTotal, o.OrderDate, o.PaymentMethod, o.Status--, od.OrderQty, od.ProductId, od.SupplierId
                FROM [Order] o
                <!--- INNER JOIN [OrderDetails] od --->
                <!--- ON o.OrderId = od.OrderId --->
                WHERE o.UserId = #SESSION.User.UserId#
            </cfquery>

            <cfcatch >
                <cflog file = "ShoppingDBlog" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
                <cfset LOCAL.response = {} />
                <cfset LOCAL.response.message = "error while querying Orders table for details of user #SESSION.User.UserName#"/>
                <cfreturn LOCAL.response />
            </cfcatch>

        </cftry>

        <cfreturn LOCAL.Orders />
    </cffunction>
</cfcomponent>
