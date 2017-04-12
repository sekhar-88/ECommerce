<cfset cartCFC = createObject("cfc.cart") />

<!DOCTYPE html>
<html>
<head>
    <cfinclude template = "/include/libraries.cfm">
    <link rel="stylesheet" href="../assets/css/cart.css">
    <script src="../assets/js/cart.js"></script>
</head>
<body>
    <cfinclude template = "/commons/header.cfm">
    <!--- page refresh logic --->
    <input type="hidden" id="refreshed" value="no"/>


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
                <cfif NOT VARIABLES.isCartEmpty>
                    <button type="button" class="btn btn-success btn-lg" onclick="checkout();">Checkout</button>
                </cfif>
            </div>
    </div>

        <cfinclude template="/commons/footer.cfm" />
    </body>
</html>
