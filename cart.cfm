<cfset cartCFC = createObject("cfc.cart") />

<!DOCTYPE html>
<html>
<head>
    <cfinclude template = "assets/libraries/libraries.cfm">
    <link rel="stylesheet" href="assets/css/cart.css">
    <script src="assets/js/cart.js"></script>
</head>
<body onload="fetchCartItems()">
    <cfinclude template = "commons/header.cfm">
    <div class="container-fluid">

        <div id="items_pane">
<!---
                #items_pane
                    .item #item_x   /    .no-item
                        .item_info           (message)
                        .item_actions
                #checkout_pane
--->
        </div>

            <div id="checkout_pane">
                <cfset VARIABLES.isCartEmpty = cartCfC.isCartEmpty()/>
                <cfif VARIABLES.isCartEmpty>
                    <button type="button" class="disabled btn btn-success btn-lg" onclick="alert('Add some products first..')">Checkout</button>
                <cfelse>
                    <button type="button" class="btn btn-success btn-lg" onclick="checkout();">Checkout</button>
                </cfif>
            </div>
    </div>

        <cfinclude template="commons/footer.cfm" />
    </body>
</html>
