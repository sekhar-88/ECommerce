<cftry>
<cfset cartCFC = createObject("cfc.cart") />

<!DOCTYPE html>
<html>
<head>
    <link rel="stylesheet" href="../assets/css/cart.css">
    <script src="../assets/js/cart.js"></script>
</head>
<body>
    <div class="page-header"><cfinclude template = "/commons/header.cfm" /></div>
    <!--- page refresh logic --->
    <input type="hidden" id="refreshed" value="no"/>

    <!---
    .container-fluid #checkout_section
        #items_pane
            .section #order_summary
                .section_header #summary_header
                    .header_text
                .subsection
                    .summary_subsection_header
                        .item_name_header
                        .item_qty_header
                        .item_price_header
                        .item_remove_header
                    .item
                        .item_name
                        .item_qty
                        .item_price
        #checkout_pane
    --->

        <div class="container-fluid checkout_section container-fluid-page">
                <cfif SESSION.loggedin>
                <div id="items_pane">

                        <div id="order_summary" class="section">
                            <div id="summary_header" class="section_header">
                                <div class="header_text">
                                    <h2 align="center">Cart</h2>
                                </div>
                            </div>

                            <cfset VARIABLES.isCartEmpty = cartCfC.isCartEmpty()/>
                            <cfif NOT VARIABLES.isCartEmpty>

                                <div class="subsection">
                                    <div class="summary_subsection_header">
                                        <div class="item_name_header">ITEMS</div>
                                        <div class="item_qty_header">QTY</div>
                                        <div class="item_price_header">PRICE</div>
                                        <div class="item_remove_header">REMOVE</div>
                                    </div>


                                    <cfset orderSummary = cartCFC.getOrderSummary( calledFrom = "cfm_page_not_ajax") />
                                    <cfloop query="orderSummary" >
                                    <cfoutput>

                                        <div class="item" data-product-id = #ProductId# data-name="#Name#">

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
                                                        <span class='glyphicon glyphicon-remove' onclick='removeFromCart(this);' data-dismiss-id="#ProductId#">
                                                        </span>
                                                    </div>

                                        </div>   <!-- end item -->

                                    </cfoutput>
                                    </cfloop>


                                    <div class="item-checkout-price">
                                        <div style="float:right;padding: 5px;">
                                            <span style="font-weight:bold; padding: 10px;">Total:</span>
                                            <span class="fa fa-inr checkoutPrice"></span> <span class="checkoutPrice" id="total-checkout-price"> </span><span class="checkoutPrice">/-</span>
                                        </div>
                                    </div>

                                </div>  <!-- end .subsection -->

                            <cfelse>
                                <div class="no-items">
                                </div>
                            </cfif>

                        </div>  <!--- end .section  --->

                    </div>   <!---  end #items pane --->
                    <cfelse>
                        <div class="guest-cart-div well well-sm">
                            <div class="login-image"></div>
                            <h4 class="jumbotron"><span>Please <a href="" data-toggle="dropdown" data-target=".login_toggle">Login</a> To view items in Cart &amp; edit<span></h4>
                        </div>
                    </cfif>

                <div id="checkout_pane">
                    <cfif SESSION.loggedin AND (NOT cartCFC.isCartEmpty()) >
                        <button type="button" class="btn btn-success btn-lg" onclick="checkout();">Checkout</button>
                    </cfif>
                </div> <!---  #checkout pane --->
        </div>  <!--- end .container-fluid --->



        <cfinclude template="/commons/footer.cfm" />
    </body>
</html>

<cfcatch>
    <cfdump var="#cfcatch#" />
    <cfabort />
</cfcatch>
</cftry>

<cfdump var="#SESSION#" />
