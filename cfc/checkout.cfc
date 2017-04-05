<cfcomponent extends="product" >
    <cfset VARIABLES.checkoutDB = CreateObject("db.checkout_db") />

    <cffunction name="refreshSessionCheckoutList" returntype="boolean" returnformat="json" access="remote">
        <cfargument name="arrayindex" required="true" type="numeric" />
        <cfset ArrayDeleteAt(session.User.checkout.itemsInfo, arguments.arrayindex)/>
    </cffunction>


    <cffunction name="getAddressesOfUser" output="false" returntype="query" access="remote" >
        <cfinvoke method="getAddressForUser" component="#VARIABLES.checkoutDB#"
            returnvariable="REQUEST.addresses"  />

        <cfreturn #REQUEST.addresses# />

    </cffunction>

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


    <cffunction name="getOrderSummary" access="remote" returntype="Struct" returnformat="json" output="false">

        <cfset totalPrice = 0 />
        <cfset itemsArray = [] />

        <cftry>
        <!--- Query for Items in Cart & their price for showing in Step 1 of (CHECKOUT PAGE)--->
                <cfinvoke method="queryOrderSummary" component="#VARIABLES.checkoutDB#"
                    returnvariable="REQUEST.itemsQuery" />

                <cfloop query="REQUEST.itemsQuery">

                    <cfif IsNull(#DiscountedPrice#)>
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
        <cfcatch>
                <cfdump var="#cfcatch#" />
        </cfcatch>
        </cftry>

        <cfreturn #itemsInfo#/>
    </cffunction>


    <cffunction name="getAvailableQuantity" returnType="Numeric" returnFormat="json" access="remote">
        <cfargument name="itemid" required="true" type="numeric" />

        <cfset LOCAL.Qty = super.getavailableProductQuantity( pid = #ARGUMENTS.itemid# ) />

        <cfreturn #LOCAL.Qty# />
    </cffunction>


    <cffunction name="saveShippingAddress" output="true" access="remote" returnformat="JSON" returntype="boolean"  >
        <cfargument name="AddressLine" type="string" required="true" >
        <cfargument name="Name"        type="string" required="true" >
        <cfargument name="LandMark"    type="string" required="true" >
        <cfargument name="PhoneNo"     type="string" required="true" >
        <cfargument name="PostalCode"  type="string" required="true" >

        <cfinvoke method="insertNewAddress" component = "#VARIABLES.checkoutDB#"
            returnvariable="REQUEST.success" argumentcollection="#ARGUMENTS#" />

        <cfif REQUEST.success>
            <cfreturn true/>
            <cfelse>
            <cfreturn false/>
        </cfif>
    </cffunction>

    <cffunction name="deleteAddress" access="remote" output="true" returntype="any" returnFormat="json">
        <cfargument name="addressid" required="true" type="numeric" />

        <cftry>
            <cfinvoke method="deleteAddress" component="#VARIABLES.checkoutDB#"
                returnvariable="REQUEST.deleteAddressSuccess" argumentcollection="#ARGUMENTS#"  />
            <cfreturn #REQUEST.deleteAddressSuccess# />
        <cfcatch>
            <cfdump var="#cfcatch#" />
            <cfreturn false/>
        </cfcatch>
        </cftry>

    </cffunction>

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

    <cffunction name="updateShippingAddress" access="remote" output="true" returntype="string" returnformat="json">
        <cfargument name="addressid" required="true" type="numeric" />
        <cfargument name="formdata" required="true" type="string" />

        <cfset LOCAL.addressObj = URLstringToObj(ARGUMENTS.formdata) />     <!--- store form data as JSON file in this thing --->
            <cfset StructInsert(LOCAL.addressObj, "Country", "India")/>

            <cfinvoke method="updateAddress" component="#VARIABLES.checkoutDB#"
                returnvariable="REQUEST.success"
                addressStruct = #LOCAL.addressObj#
                addressid = #ARGUMENTS.addressid# />

            <cfreturn #REQUEST.success# />

    </cffunction>

    <cffunction name="orderPlacedByCOD" output="false" returntype="Struct" returnformat="JSON" access="remote">
        <cfset response = {}/>
        <cfset subTotal = getCartTotal()/>

        <cftry>
            <!--- INSERT INTO ORDER TABLE --->
            <cfquery name="insertToOrderTable" result="insertedOrder">
                INSERT INTO [Order]
                (UserId, SubTotal, OrderDate, PaymentMethod, Status)
                VALUES
                (#session.User.UserId#, #subTotal#, GETDATE(), 'COD', 'Processing')
            </cfquery>

            <!--- GET GENERATED ORDER_ID OF ORDERS TABLE --->
            <cfset variables.OrderId = #insertedOrder.GENERATEDKEY#/>

            <!--- GET REQUIRED ITEMS FOR INSERTING INTO ORDERDETAILS TABLE --->
            <cfquery name="cart"> <!--- \/ & OrderId, ShipToAddressId --->
                SELECT c.ProductId, p.ListPrice AS UnitPrice, c.Qty AS OrderQty, p.SupplierId
                FROM [Cart] c

                inner join [Product] p
                on c.ProductId = p.ProductId

                WHERE c.UserId = #session.User.UserId#
            </cfquery>

            <!--- INSERT INTO ORDERDETAILS TABLE USING cart QUERY--->

            <cfquery name="updateOrderDetails">
                <cfloop query="cart" >
                    INSERT INTO [OrderDetails]
                    (OrderId, ProductId, OrderQty, UnitPrice, ShipToAddressId, SupplierId)
                    VALUES
                    (#variables.OrderId#, #cart.ProductId#, #cart.OrderQty#, #cart.UnitPrice#, #session.User.checkout.AddressId#, #cart.SupplierId# )
                </cfloop>
            </cfquery>

            <cfset cartCleared = clearCart()/>
            <cfif cartCleared>
                <cfset session.cartDataChanged = true/>
                <cfset StructInsert(response, "status", "true")/>
                <cfelse>
                <cfset StructInsert(response, "status", "false")/>
            </cfif>

        <cfcatch>
            <cfset StructInsert(response, "status", "false")/>
            <cfdump var="#cfcatch#" />
        </cfcatch>
        </cftry>
        <cfreturn #response#/>
    </cffunction>

    <cffunction name="updateCartAndTotalPrice" returntype="Any" returnformat="JSON" access="remote" output="false">
        <cfargument name="cartid" required="true" type="numeric"/>
        <cfargument name="pid" required="true" type="numeric"  />
        <cfargument name="qty" required="true" type="numeric" />

        <cfset price = getPriceOfProduct(ARGUMENTS.pid)/>
        <cfset LOCAL.totalPrice = price * #ARGUMENTS.qty# />

        <cftry>
            <cfinvoke method="updateCartAndTotalPrice" component="#VARIABLES.checkoutDB#"
                returnvariable = "REQUEST.success"
                argumentcollection="#ARGUMENTS#"
                totalPrice = #LOCAL.totalPrice# />

            <cfset LOCAL.totalCartPrice = getCartTotal()/>
            <cfreturn #LOCAL.totalCartPrice#/>

            <cfcatch>
                <cfdump var="#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>


    <cffunction name="getCartTotal" returntype="Numeric" access="remote" output="true" >

        <cftry>
            <cfinvoke method="getCartTotal" component="#VARIABLES.checkoutDB#"
                returnvariable="REQUEST.total" />

            <cfcatch>
            <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>

        <cfreturn #REQUEST.total# />
    </cffunction>


 <!--- DELETE CART ITEMS AFTER INSERTING INTO ORDER DETAILS SECTIOIN --->
    <cffunction name="clearCart" returntype="boolean" access="remote">
        <cftry>
            <cfinvoke method="clearCart" component="#VARIABLES.checkoutDB#"
                returnvariable="REQUEST.success" />

                <cfreturn #REQUEST.success# />

            <cfcatch >
                <cfreturn false/>
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>

    </cffunction>

    <cffunction name="getPriceOfProduct" access="remote" returntype="boolean" output="true">
        <cfargument name="pid" required="true" type="numeric"/>

        <cfset LOCAL.productPrice = super.getPriceOfProduct(pid = ARGUMENTS.pid)/>
        <cfreturn #LOCAL.productPrice# />

    </cffunction>

</cfcomponent>
