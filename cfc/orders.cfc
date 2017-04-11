<cfcomponent>

    <cfset VARIABLES.orderDB = CreateObject("db.order_db") />
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


<!---
    returns query containing the order details for showing in the order deatils page ..
    returns to the "orderDetails" variable in the orders page.
--->
    <cffunction name="getOrderDetails" access="remote" returntype="query" >
        <cfargument name="OrderId" type="numeric" required = "true" />

        <cfinvoke method="getOrderDetails" component="#VARIABLES.orderDB#"
            returnvariable="REQUEST.orderDetails" OrderId = #ARGUMENTS.OrderId# />

        <cfreturn REQUEST.orderDetails />
    </cffunction>


</cfcomponent>
