<cfcomponent>
    <cffunction name="refreshSessionCheckoutList" returntype="boolean" returnformat="json" access="remote">
        <cfargument name="arrayindex" required="true" type="numeric" />
        <cfset ArrayDeleteAt(session.User.checkout.itemsInfo, arguments.arrayindex)/>
    </cffunction>


    <cffunction name="getAddressesOfUser" output="false" returntype="query" access="remote" >
        <cftry >
            <cfquery name="addresses">
                SELECT *
                FROM [Address]
                WHERE UserId = #session.user.userid#
            </cfquery>
            <cfreturn #addresses# />
        <cfcatch>
            <cfreturn #cfcatch# />
        </cfcatch>
        </cftry>
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


    <cffunction output="false" name="getOrderSummary" access="remote" returntype="Struct" returnformat="json">

        <cfset totalPrice = 0 />
        <cfset itemsArray = [] />

        <cftry>
        <!--- Query for Items in Cart & their price for showing in Step 1 of (CHECKOUT PAGE)--->
                <cfquery name="itemsQuery">
                    SELECT c.CartId, c.ProductId, c.Qty , p.Name, p.ListPrice , p.DiscountedPrice, p.Description
                    from [Cart] c
                    inner join [Product] p
                    ON c.ProductId = p.ProductId
                    Where c.UserId = #session.User.UserId#
                </cfquery>

                <cfloop query="itemsQuery">

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
                           "description" = #Description#
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


    <cffunction name = "getAvailableQuantity" returnType="Numeric" returnFormat="json" access="remote">
        <cfargument name="itemid" required="true" type="numeric" />

        <cftry>
            <cfquery name="quantity">
                SELECT Qty
                FROM [Product]
                WHERE ProductId = #arguments.itemid#
            </cfquery>
            <cfreturn #quantity.Qty#>
            <cfcatch>
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>


    <cffunction name="saveShippingAddress" output="true" access="remote" returnformat="JSON" returntype="boolean"  >
        <cfargument name="AddressLine" type="string" required="true" >
        <cfargument name="Name"        type="string" required="true" >
        <cfargument name="LandMark"    type="string" required="true" >
        <cfargument name="PhoneNo"     type="string" required="true" >
        <cfargument name="PostalCode"  type="string" required="true" >
        <cftry >
            <cfquery >
                INSERT INTO [Address]
                (UserId,AddressLine,Name,LandMark,PhoneNo,PostalCode,Country,AddressType)
                VALUES
                (   #session.User.UserId#,
                    <cfqueryparam value="#arguments.AddressLine#" />,
                    <cfqueryparam value="#arguments.Name#"       cfsqltype="cf_sql_nvarchar">    ,
                    <cfqueryparam value="#arguments.LandMark#"   cfsqltype="cf_sql_nvarchar">    ,
                    <cfqueryparam value="#arguments.PhoneNo#"    cfsqltype="cf_sql_nvarchar">,
                    <cfqueryparam value="#arguments.PostalCode#" cfsqltype="cf_sql_nvarchar">,
                    'India',
                    0
                )
            </cfquery>
                <cfreturn true/>
            <cfcatch >
                <cfdump var="#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="deleteAddress" access="remote" output="true" returntype="any" returnFormat="json">
        <cfargument name="addressid" required="true" type="numeric" />
        <cftry>
            <cfquery name="deleteAddress">
                DELETE FROM [Address]
                WHERE AddressId = <cfqueryparam value="#arguments.addressid#" cfsqltype="CF_SQL_BIGINT"  />
            </cfquery>
            <cfreturn true/>
        <cfcatch>
            <cfdump var="#cfcatch#" />
            <cfreturn false/>
        </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="updateShippingAddress" access="remote" output="false" returntype="string" returnformat="json">
        <cfargument name="addressid" required="true" type="numeric" />
        <cfargument name="formdata" required="true" type="string" />

            <cfset formJSON = {}/>     <!--- store form data as JSON file in this thing --->

            <cfloop list="#arguments.formdata#" index="i" delimiters="&" >
                <cfset key= ListFirst(i , "=")/>
                <cfset value = urlDecode(ListLast(i , "="))/>
                <cfset StructInsert(formJSON, #key#, #value#)/>
            </cfloop>
                <cfset StructInsert(formJSON, "Country", "India")/>

            <cftry>
            <cfquery name = "updateAddress">                    <!--- start updaing the address of the corresponding User --->
                <cfloop collection="#formJSON#" item="item" >
                    update [Address]
                    set #item# = <cfqueryparam value="#formJSON[item]#" cfsqltype="cf_sql_nvarchar" />
                    where AddressId = <cfqueryparam value="#arguments.addressid#" cfsqltype="cf_sql_bigint" />
                </cfloop>
                    update [Address]
                    set UserId = #session.User.UserId#,
                        AddressType = 0
                    where AddressId = <cfqueryparam value="#arguments.addressid#" cfsqltype="cf_sql_bigint" />
            </cfquery>
            <cfreturn true/>
            <cfcatch >
                <cfdump var="#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
            </cftry>

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

        <cfset price = getPriceOfProduct(#arguments.pid#)/>
        <cfset totalPrice = price * #arguments.qty# />

        <cftry>
            <cfquery>
                UPDATE [Cart]
                SET Qty = <cfqueryparam value="#arguments.qty#" cfsqltype="cf_sql_int" />,
                    TotalPrice = <cfqueryparam value="#totalPrice#" cfsqltype="cf_sql_bigint" />
                WHERE CartId = <cfqueryparam value="#arguments.cartid#" cfsqltype="cf_sql_bigint" />
            </cfquery>

            <cfset totalCartPrice = getCartTotal()/>
            <cfreturn #totalCartPrice#/>

            <cfcatch>
                <cfdump var="#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>



    <cffunction name="getCartTotal" returntype="Numeric" access="remote" output="true">
        <cfset sumTotal = 0/>

        <cftry>
            <cfquery name="cartPrices">
                SELECT TotalPrice
                from [Cart]
                Where UserId = #session.User.UserId#
            </cfquery>

                <cfloop query="cartPrices" >
                <cfset sumTotal += #TotalPrice# />
                </cfloop>

            <cfcatch>
            <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>

        <cfreturn #sumTotal#/>
    </cffunction>


 <!--- DELETE CART ITEMS AFTER INSERTING INTO ORDER DETAILS SECTIOIN --->
    <cffunction name="clearCart" returntype="boolean" access="remote">
        <cftry>
            <cfquery name="clearCart">
                DELETE FROM [Cart]
                WHERE UserId = #session.User.UserId#
            </cfquery>
            <cfreturn true/>

            <cfcatch >
                <cfreturn false/>
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getPriceOfProduct" access="remote" returntype="boolean" output="true">
        <cfargument name="pid" required="true" type="numeric"/>

        <cfquery name="ProductPrice">
            SELECT ListPrice
            FROM [Product]
            WHERE ProductId = <cfqueryparam value="#arguments.pid#" cfsqltype="cf_sql_bigint" />
        </cfquery>
        <cfreturn #ProductPrice.ListPrice#/>
    </cffunction>

</cfcomponent>
