<!---
    Controller name: order.cfc
    contains the functions based on order / order details page.     
--->

<cfcomponent>

    <cfset VARIABLES.orderDB = CreateObject("db.order_db") />
    <!--- getst the Orders from the Order Table for the User --->

    <cffunction name="getOrders" access="remote" returntype="query" >

        <cfset LOCAL.Orders = VARIABLES.orderDB.getOrdersFromDB() />
        <cfreturn LOCAL.Orders />
    </cffunction>


<!---
    returns query containing the order details for showing in the order deatils page ..
    returns to the "orderDetails" variable in the orders page.
--->
    <cffunction name="getOrderDetails" access="remote" returntype="query" >
        <cfargument name="OrderId" type="numeric" required = "true" />

        <cfset LOCAL.orderDetails = VARIABLES.orderDB.getOrderDetails(OrderId = #ARGUMENTS.OrderId#) />

        <cfreturn LOCAL.orderDetails />
    </cffunction>


</cfcomponent>
