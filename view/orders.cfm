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
            <h4>My Orders ></h4>

            <cfif orders.recordCount>

                <cfloop query="orders" >
                <div class="orders">
                    <div class="order-header">
                        <div class="order-id">ORDER : OD#OrderId#</div>
                    </div>

                    <cfset orderDetails = ordersCFC.getOrderDetails(#OrderId#) />
                    <cfloop query="orderDetails" >
                    <div class="order">

                            <div class="order-img"> <div class="img" style=" background-image: url('../assets/images/products/medium/#Image#');" onclick="javascript: location.href='productDetails.cfm?pid=#ProductId#'"></div> </div>
                            <div class="order-info">
                                <div class="product-name">#ProductName#</div>
                                <ul class="product-desc">
                                    <cfloop index="i" list="#Description#" delimiters="`"  >
                                        <li>#i#</li>
                                    </cfloop>
                                </ul>
                            </div>
                            <div class="order-qty-price">
                                <div class="qty">Quantity : <span>#OrderQty#</span></div>
                                <cfset price = #OrderQty# * #UnitPrice# />
                                <div class="price">Price : <span>#price#</span></div>
                            </div>
                            <div class="order-shippingaddress">
                                <h3 class="shipping-header">Shipping Address</h3>
                                <div class="inner-content">
                                    <div>#PersonName# </div>
                                    <div>#AddressLine#  </div>
                                    <div>#PostalCode#   </div>
                                    <div>Phone - #PhoneNo#  </div>
                                </div>
                            </div>
                    </div>
                    </cfloop>


                    <div class="order-footer">
                        <div class="order-date">Order Date: <span>#OrderDate#</span></div>
                        <div class="order-total">Order Total: <span>&##8377; #SubTotal# </span></div>
                    </div>
                </div>
                </cfloop>

            <cfelse>
                <div class="no-orders">You have no orders, Buy some thing to show up here.</div>
            </cfif>

        </div>  <!--- end .orders-container --->
    </div>      <!--- end .container-fluid --->
    </cfoutput>


    <cfinclude template = "/commons/footer.cfm">
</body>
</html>
