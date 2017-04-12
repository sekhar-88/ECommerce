<cfset cartCFC = createObject("cfc.cart") />

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="../assets/css/cart.css">
    <script src="../assets/js/cart.js"></script>
</head>
<body>
    <cfinclude template = "/commons/header.cfm">
    <!--- page refresh logic --->
    <input type="hidden" id="refreshed" value="no"/>

    <!---
        #items_pane
        .item #item_x   /    .no-item
        .item_info           (message)
        .item_actions
        #checkout_pane
    --->

    <cfset orderSummary = cartCFC.getOrderSummary( calledFrom = "not_ajax") />
    <div class="container-fluid checkout_section">

            <div id="items_pane">

                <div id="order_summary" class="section">
                    <div id="summary_header" class="section_header">
                        <div class="header_text"><h3 align="center">Cart</h3></div>
                    </div>
        <!---
        .subsection .items
                    .summary_subsection_header
                        .item_name_header
                        .item_qty_header
                        .item_price_header
                    .item
                        .item_name
                        .item_qty
                        .item_price
        --->
                    <div class="subsection">
                        <div class="summary_subsection_header">
                            <div class="item_name_header">ITEMS</div>
                            <div class="item_qty_header">QTY</div>
                            <div class="item_price_header">PRICE</div>
                            <div class="item_remove_header">REMOVE</div>
                        </div>

                        <cfloop query="orderSummary" >
                        <cfoutput>
                        <div class="item" data-product-id = #ProductId# >

                            <div class="itemInfo">
                                <div>
                                    <div class='cart_product_image'>
                                    <img class='cart_thumbnail' src='../assets/images/products/medium/#Image#' />
                                    </div>
                                    <h4>#Name#</h4>
                                </div>
                            </div>

                            <div class="itemQty">
                                <span>
                                    <span class='inputItemsQuantityleft'>Qty:</span>
                                    <cfset maxQty = cartCFC.getAvailableQuantity(#ProductId#) />
                                    <input type='number' data-toggle='tooltip' title='Invalid Amount' data-card_id ='#CartId#' data-item_id="#ProductId#" data-item_price='#ListPrice#' name='itemQty' value='#Qty#' min='1' max='#maxQty#' class='inputItemsQuantity' onkeyup='validateItemCount( this, this.value, this.max, #CartId# )' onmouseup='validateItemCount( this, this.value, this.max, #CartId# )'>
                                </span>
                            </div>

                            <div class="itemPrice">
                                <div>
                                    &##8377; #ListPrice#
                                </div>
                            </div>

                            <div class="item_remove_icon">
                                <span class='glyphicon glyphicon-remove' data-name="#Name#" onclick='removeFromCart(this);' data-dismiss-id="#ProductId#">
                                </span>
                            </div>

                        </div>
                        </cfoutput>
                        </cfloop>

                        <div>
                            <!--- <button type="button" class="btn btn-lg btn-success" onclick="if(validateItemQuantity()) { gotoPaymentSection(this);}" style="float:right; box-shadow:1px 1px 5px lightgrey;">Checkout</button> --->
                            <div style="float:right;padding: 5px;">
                                <span style="font-weight:bold; padding: 10px;">Total:</span>
                                <span class="fa fa-inr checkoutPrice"></span> <span class="checkoutPrice" id="total-checkout-price"> </span><span class="checkoutPrice">/-</span>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
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
