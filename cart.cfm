<!DOCTYPE html>
<html>
<head>
    <cfinclude template = "assets/libraries/libraries.cfm">
    <link rel="stylesheet" href="assets/css/cart.css">
    <script src="assets/js/cart.js"></script>
</head>
<body>
    <cfinclude template = "commons/header.cfm">
    <cfset cartCFC = createObject("cfc.cart")/>
    <div class="container-fluid">

        <div id="items_pane">           <!---    #items_pane > (.item / .no_item)   &   .item > ( item_info, item_actions) --->
        <cfif session.loggedin>
            <cfset userid= #SESSION.User.UserId# />
            <cftry>
                <cfquery name="products">
                    SELECT c.*,p.Name
                    from [Cart] c
                    INNER JOIN [Product] p
                    ON c.ProductId = p.ProductId
                    WHERE c.UserId = #userid#
                </cfquery>
            <cfcatch>
                <cfoutput>
                    #cfcatch#
                </cfoutput>
            </cfcatch>
            </cftry>

            <cfif products.recordCount>
                <cfoutput>
                    <!--- PRODUCT IN LOGGED USER'S CART --->
                    <cfloop query="products">
                        <div id="item_#ProductId#" class="item">
                            <div class="item_info">  <!---pull left   .item >> .item-info --->
                                #ProductId#  #Name#
                            </div>
                            <div class="item_actions"> <!--- pull right   .item >> .item_actions --->
                                <button type="button" class="btn btn-warning" onclick="user_removeFromCart(#ProductId#);">Remove</button>
                            </div>
                        </div>
                    </cfloop>
                </cfoutput>
            <cfelse>
                <cfoutput>
                    <div class="no-item">
                        <h4 align="center" style="color: ##aaa;text-decoration:lowercase;">no items in your cart</h4>
                    </div>
                </cfoutput>
            </cfif>
        <cfelse>  <!---NOT LOGGEDIN  -   product in session Cart --->
            <cftry>
                <!--- <cfset ArrayAppend(session.cart, 0)/> --->
                <cfif NOT ArrayIsEmpty(session.cart)>
                    <cfset cart_list = ArrayToList(session.cart)/>

                    <cfquery name="products">
                        SELECT *
                        FROM [Product] p
                        WHERE ProductId IN
                        (
                        <cfqueryparam
                        value = '#cart_list#'
                        cfsqltype="cf_sql_integer"
                        list = 'yes' >
                        )
                    </cfquery>
                    <cfoutput>
                        <!--- PRODUCT IN LOGGED USER'S CART --->
                        <cfloop query="products">
                            <div id="item_#ProductId#" class="item">
                                <div class="item_info"> <!---pull left   .item >> .item-info --->
                                    #ProductId#  #Name#
                                </div>
                                <div class="item_actions">  <!--- pull right   .item >> .item_actions --->
                                    <button type="butotn" class="btn btn-warning" onclick="removeFromSessionCart(#ProductId#)">Remove</button>
                                </div>
                            </div>
                        </cfloop>
                    </cfoutput>
                <cfelse>
                    <cfoutput>
                        <div class="no_item"> <!--- items div subsection--->
                            no items in your cart
                        </div>
                    </cfoutput>
                </cfif>
            <cfcatch>
                <cfdump var="#cfcatch#" />
            </cfcatch>
            </cftry>
        </cfif>
            </div>

            <div id="checkout_pane">
                <cfset isCartEmpty = cartCfC.isCartEmpty()/>
                <cfif isCartEmpty>
                    <button type="button" class="disabled btn btn-success btn-lg" onclick="alert('Add some products first..')">Checkout</button>
                <cfelse>
                    <button type="button" class="btn btn-success btn-lg" onclick="checkout();">Checkout</button>
                </cfif>
            </div>

        </div>

        <cfinclude template="commons/footer.cfm" />
    </body>
</html>
