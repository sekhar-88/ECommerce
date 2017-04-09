<cfset ordersCFC = CreateObject("cfc.orders") />

<!DOCTYPE html>
<html>
<head>
    <cfinclude template="assets/libraries/libraries.cfm" />
</head>
<body>
    <cfinclude template = "commons/header.cfm" />

    <cfif NOT SESSION.loggedin>
        <cfoutput>
            <h1 color="red">Not loggged in</h1>
        </cfoutput>
    </cfif>

    <div class="container-fluid">
        <div class="orders-container">

            <div class="orders">
                <cfset orders = ordersCFC.getOrders() />
                <cfloop query="orders" >
                    <cfoutput>
                    OrderId : #OrderId# <br />


                    <div class="order">
                        <cfset orderDetails = ordersCFC.getOrderDetails(#OrderId#) />
                        <cfloop query="orderDetails" >
                            OrderId : #OrderId#
                            Products: #ProductId# <br />
                            Shipping to : #AddressLine# <br />
                        </cfloop>


                    </div>

                    </cfoutput>
                </cfloop>

            </div>

        </div>
    </div>


    <cfinclude template = "commons/footer.cfm">
</body>
</html>
