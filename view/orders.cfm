<cfset ordersCFC = CreateObject("cfc.orders") />

<!DOCTYPE html>
<html>
<head>
    <link href="../assets/css/orders.css" rel="stylesheet">
</head>
<body>
    <cfinclude template = "/commons/header.cfm" />

    <cfif NOT SESSION.loggedin>
        <cfoutput>
            <h1 color="red">Not logged in</h1>
        </cfoutput>
    <cfelse>
        <!--- show page header - it is outside of container-fluid so displays in full width --->
        <h2 class="order-page-header" align="center">Order Details History</h2>
    </cfif>


<!--- page statrs --->
    <cfoutput>
    <div class="container-fluid">

        <cfset orders = ordersCFC.getOrders() />
        <div class="orders-container">

            <cfloop query="orders" >
            <div class="orders">

                in orders query : #OrderId#
                <cfset orderDetails = ordersCFC.getOrderDetails(#OrderId#) />
                <cfloop query="orderDetails" >
                <div class="order">

                        in OrderDetails:
                        OrderId     : #OrderId#
                        Products    : #ProductId# <br />
                        Shipping to : #AddressLine# <br />

                </div>
                </cfloop>

            </div>
            </cfloop>

        </div>  <!--- end .orders-container --->
    </div>      <!--- end .container-fluid --->
    </cfoutput>


    <cfinclude template = "/commons/footer.cfm">
</body>
</html>
