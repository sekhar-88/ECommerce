<!---
    Controller name: checkout.cfc
    contains functionalities of checkout page.
--->

<cfcomponent extends="product" >
    <cfset VARIABLES.checkoutDB = CreateObject("db.checkout_db") />

    <!--- deletes the session cart data in User section of the session while in different checkout steps ..  --->
    <cffunction name="refreshSessionCheckoutList" returntype="boolean" returnformat="json" access="remote">
        <cfargument name="arrayindex" required="true" type="numeric" />
        <cfset ArrayDeleteAt(session.User.checkout.itemsInfo, arguments.arrayindex)/>
    </cffunction>

    <!--- gets the shipping addresses of a user--->
    <cffunction name="getAddressesOfUser" output="false" returntype="query" access="remote" >
        <cfset LOCAL.addresses = VARIABLES.checkoutDB.getAddressForUser() />

        <cfreturn LOCAL.addresses />
    </cffunction>


    <!--- gets the checkout step for the checkout page 1 for address section & 2 for order review session. --->
    <cffunction name="getCheckOutStep" access="remote" returntype="numeric" returnFormat="json" >
        <cftry>
        <!---   if loggedin > if cartdata cartDataChanged  > if at checkout step 1
                |              |                              /delete item info in checkout structure(created for easy product information retrieval)
                |              /return user at step
                /return -1 --->

            <cfif session.loggedin>
                <cfif session.cartDataChanged>
                    <cfif session.User.checkout.step EQ 1>
                        <!--- remove the checkout  - "items info" structure from "session.user.checkout" --->
                        <!--- It was created while we clicked "deliver here" in the step 0 --->
                        <!--- <cfset StructClear(session.User.checkout.itemsInfo)> <!---will not work as this is now an Array  ---> --->
                        <cfset ArrayClear(session.User.checkout.itemsInfo) /> <!---  delete the array --->
                        <cfset session.User.checkout.step = 0/>
                    </cfif>
                    <cfset session.cartDataChanged = false/>
                    <cfreturn 0/>
                <cfelse>
                    <cfreturn #session.User.checkout.step#/>
                </cfif>
            <cfelse>
                <cfreturn -1/>
            </cfif>

        <cfcatch>
            <cfdump var="#cfcatch#" />
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- sets checkout address in session after choosing a delivery address.  --->
    <cffunction name="setCheckoutAddress" output="true" returntype="boolean" returnformat="json" access="remote" >
        <cfargument name="addressid" required="true" type="numeric" />
        <cftry >
            <cfset session.User.checkout.step = 1/>
            <cfset StructInsert(session.User.checkout, "AddressId", #arguments.addressid#)/>
            <cfset session.cartDataChanged = false/>
            <cfreturn true/>
        <cfcatch >
            <cfdump var="#cfcatch#"/>
        </cfcatch>
        </cftry>
    </cffunction>


    <!--- reverting the step 1 or 2 depending on the user clicked on choose delivery address or
    review order button after going into the next step on checkout page. --->
    <cffunction name="revertToStep" output="true" access="remote" returnType="boolean" returnFormat="json">
        <cfargument name="step" type="numeric" required="true" />

                <cfswitch expression= "#arguments.step#" >
                    <cfcase value="0" >
                        <cfset StructDelete(session.User.checkout, "AddressId")/>
                        <cfset StructDelete(session.User.checkout, "totalPrice")/>
                        <cfset session.User.checkout.step = 0 />
                        <cfreturn true/>
                    </cfcase>
                    <cfcase value="1" >

                    </cfcase>
                    <cfdefaultcase >
                        <cfreturn false/>
                    </cfdefaultcase>
                </cfswitch>
    </cffunction>


<!---
this function returns cart items details &  price & image for showing in cart section & checkout section
    it requries an argument .. called from which returns query if called from a page & returns JS array
    if it was calledfrom ajax
--->
    <cffunction name="getOrderSummary" access="remote" returntype="Any" returnformat="json" output="false">
        <cfargument name="calledFrom" type="string" required = "true" />

        <cfset totalPrice = 0 />
        <cfset itemsArray = [] />

        <cftry>
        <!--- Query for Items in Cart & their price for showing in Step 1 of (CHECKOUT PAGE)--->
            <cfset LOCAL.itemsQuery = VARIABLES.checkoutDB.queryOrderSummary() />

            <cfif ARGUMENTS.calledFrom EQ 'ajax' >

                    <cfloop query="LOCAL.itemsQuery">

                        <cfif IsNull(#DiscountedPrice#) >
                            <cfset dscnt = false />
                            <cfelse>
                            <cfset dscnt = true />
                        </cfif>

                        <cfset ArrayAppend(itemsArray, {
                               "cartId"= #CartId#,
                               "id"    = #ProductId#,
                               "name"  = "#Name#",
                               "qty"   = #Qty#,
                               "price" = #ListPrice#,
                               "discount"  = #dscnt#,
                               "discountedPrice"   = #DiscountedPrice#,
                               "description" = #Description#,
                               "image" = #Image#
                               }) />
                    </cfloop>
                    <!--- SET the step 1 checkout variables inside session --->
                    <cfset session.User.checkout.totalPrice = #totalPrice# />
                    <cfset session.User.checkout.itemsInfo = #itemsArray#/>
                    <cfset totalPrice = getCartTotal() />

                    <cfset itemsInfo= {
                        "totalPrice" = #totalPrice#,
                        "itemsArray" = #itemsArray#
                    } />

            <cfelse>
                <cfreturn LOCAL.itemsQuery />

            </cfif>

            <cfcatch>
                    <cfdump var="#cfcatch#" />
            </cfcatch>

        </cftry>

        <cfreturn #itemsInfo#/>
    </cffunction>

    <!--- get the product available quantity for the particular product. --->
    <cffunction name="getAvailableQuantity" returnType="Numeric" returnFormat="json" access="remote">
        <cfargument name="itemid" required="true" type="numeric" />

        <cfset LOCAL.Qty = super.getavailableProductQuantity( pid = #ARGUMENTS.itemid# ) />

        <cfreturn #LOCAL.Qty# />
    </cffunction>

    <!--- insert a new shipping address for the user . --->
    <cffunction name="saveShippingAddress" output="true" access="remote" returnformat="JSON" returntype="boolean"  >
        <cfargument name="AddressLine" type="string" required="true" >
        <cfargument name="Name"        type="string" required="true" >
        <cfargument name="LandMark"    type="string" required="true" >
        <cfargument name="PhoneNo"     type="string" required="true" >
        <cfargument name="PostalCode"  type="string" required="true" >

        <cfset LOCAL.success = VARIABLES.checkoutDB.insertNewAddress( argumentcollection="#ARGUMENTS#" ) />

        <cfif LOCAL.success>
            <cfreturn true/>
            <cfelse>
            <cfreturn false/>
        </cfif>
    </cffunction>


    <!--- delete a shipping address mark deleted in db. --->
    <cffunction name="deleteAddress" access="remote" output="true" returntype="any" returnFormat="json">
        <cfargument name="addressid" required="true" type="numeric" />

        <cftry>
            <cfset LOCAL.deleteAddressSuccess = VARIABLES.checkoutDB.deleteAddress( argumentcollection="#ARGUMENTS#" ) />
            <cfreturn LOCAL.deleteAddressSuccess />
        <cfcatch>
            <cfdump var="#cfcatch#" />
            <cfreturn false/>
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- decode the URL into a general string. & extract a stringified OBJ/structure --->
    <cffunction name="URLstringToObj" returntype="struct" access= "public" >
        <cfargument name="formdata" type="string" required = "true" />

        <cfset formStruct = {}/>

        <cfloop list="#ARGUMENTS.formdata#" index="i" delimiters="&" >
            <cfset key= ListFirst(i , "=")/>
            <cfset value = urlDecode(ListLast(i , "="))/>
            <cfset StructInsert(formStruct, #key#, #value#)/>
        </cfloop>

        <cfreturn #formStruct# />
    </cffunction>


    <!--- save the shipping address after updating the address.. not used may be. --->
    <cffunction name="updateShippingAddress" access="remote" output="true" returntype="string" returnformat="json">
        <cfargument name="addressid" required="true" type="numeric" />
        <cfargument name="formdata" required="true" type="string" />

        <cfset LOCAL.addressObj = URLstringToObj(ARGUMENTS.formdata) />     <!--- store form data as JSON file in this thing --->
            <cfset StructInsert(LOCAL.addressObj, "Country", "India")/>

            <cfset LOCAL.success = VARIABLES.checkoutDB.updateAddress( addressStruct = #LOCAL.addressObj#, addressid = #ARGUMENTS.addressid# ) />

            <cfreturn #LOCAL.success# />
    </cffunction>

    <!--- order placed by COD (cash on delivery)
            insert into order table..   get generated .. order id...
            insert into order details table... etc..
    --->
    <cffunction name="orderPlacedByCOD" output="true" returntype="Struct" returnformat="JSON" access="remote">
        <cfset response = {}/>
        <!--- <cfset subTotal = getCartTotal()/> --->

        <cftransaction>

            <cftry>
                <!--- INSERT INTO ORDER TABLE --->
                <cfset LOCAL.insertedOrder = VARIABLES.checkoutDB.insertToOrderTable() />

                <!--- GET GENERATED ORDER_ID from QUERY result & ITEM DETAILS from Cart --->
                <cfset LOCAL.OrderId = #LOCAL.insertedOrder.GENERATEDKEY#/>
                <cfset LOCAL.cartItemDetails = VARIABLES.checkoutDB.getProductsDetailFromCart() />

                <!--- INSERT INTO ORDERDETAILS TABLE USING cart QUERY--->
                <cfset VARIABLES.checkoutDB.insertToOrderDetails(cartItemDetails = LOCAL.cartItemDetails, orderId = LOCAL.OrderId) />


                <cfset cartCleared = clearCart()/>
                <cfif cartCleared>
                    <cfset session.cartDataChanged = true/>
                    <cfset StructInsert(response, "status", "true")/>
                    <cfelse>
                    <cfset StructInsert(response, "status", "false")/>
                </cfif>

            <cfcatch>
                <cftransaction action="rollback" />
                <cfset StructInsert(response, "status", "false")/>
                <cfdump var="#cfcatch#" />
            </cfcatch>
            </cftry>

        </cftransaction>

        <cfreturn #response#/>
    </cffunction>

    <!---
        UPDATE CART ITEM COUNT & UPDATE THE TOTAL PRICE AS SUCH
        & RETURN THE TOTAL PRICE OF PRODUCTS IN CART
    --->
    <cffunction name="updateCartAndTotalPrice" returntype="Any" returnformat="JSON" access="remote" output="false">
        <cfargument name="cartid" required="true" type="numeric"/>
        <cfargument name="pid" required="true" type="numeric"  />
        <cfargument name="qty" required="true" type="numeric" />

        <cfset LOCAL.price = getPriceOfProduct(ARGUMENTS.pid) />
        <cfset LOCAL.totalPrice = LOCAL.price * #ARGUMENTS.qty# />

        <cftry>
            <cfset LOCAL.success = VARIABLES.checkoutDB.updateCartAndTotalPrice(argumentcollection = "#ARGUMENTS#", totalPrice = #LOCAL.totalPrice#) />

            <cfset LOCAL.totalCartPrice = getCartTotal()/>
            <cfreturn #LOCAL.totalCartPrice#/>

            <cfcatch>
                <cfdump var="#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- Calculate Total total amount of Cart --->
    <cffunction name="getCartTotal" returntype="Numeric" returnFormat="JSON" access="remote" output="true" >

        <cftry>
                <cfset LOCAL.total = VARIABLES.checkoutDB.getCartTotal() />

                <cfif LOCAL.total EQ -1 >
                    <!--- user not loggedin --->
                    <cfreturn 0 />
                </cfif>

            <cfcatch>
                <cfdump var="#cfcatch#" />
            </cfcatch>

        </cftry>

        <cfreturn #LOCAL.total# />
    </cffunction>


 <!--- DELETE CART ITEMS AFTER INSERTING INTO ORDER DETAILS SECTIOIN --->
    <cffunction name="clearCart" returntype="boolean" access="remote">
        <cftry>
            <cfset LOCAL.success = VARIABLES.checkoutDB.clearCart() />
            <cfreturn #LOCAL.success# />

            <cfcatch >
                <cfreturn false/>
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- get the price of a product given its Product ID --->
    <cffunction name="getPriceOfProduct" access="remote" returntype="boolean" output="true">
        <cfargument name="pid" required="true" type="numeric"/>

        <cfset LOCAL.productPrice = super.getPriceOfProduct(pid = ARGUMENTS.pid)/>
        <cfreturn #LOCAL.productPrice# />
    </cffunction>

    <!--- check for cart data chaged (session variable) or not. from JAVASCRIPT
        used for checking if the cart Data (items , quantity , or something changed or not .. )
        depending on resets the ckeout step  in checkout page.. & used in some error handling. --->
    <cffunction name="isCartDataChanged" returntype="boolean" returnformat="json" access="remote" >
        <cfreturn SESSION.cartDataChanged
        />
    </cffunction>

<!---
    this function sets the payment data changed to false
    while going into the payments section after reviewing the order
 --->
    <cffunction name="setPaymentDataChangedToFalse" returntype = "boolean" returnformat = "JSON" access = "remote" >

        <cfif SESSION.User.paymentDataChanged >
            <cfset SESSION.User.paymentDataChanged = false />
        </cfif>

        <cfreturn true />
    </cffunction>

<!--- simply returns if the paymentData changed or not in User session Scope  --->
    <cffunction name="isPaymentDataChanged" returntype = "boolean" returnformat = "JSON" access = "remote" output = "true">
        <cftry >
            <cfreturn SESSION.User.paymentDataChanged />
            <cfcatch >
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>

</cfcomponent>
