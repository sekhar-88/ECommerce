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

    <cffunction output="false" name="getOrderSummary" access="remote" returntype="Array" returnformat="json">
        <cftry>
        <!--- Query for Items in Cart & their price for showing in Step 1 of (CHECKOUT PAGE)--->
                <cfquery name="itemsQuery">
                    SELECT c.ProductId, c.Qty , p.Name, p.ListPrice , p.DiscountedPrice
                    from [Cart] c
                    inner join [Product] p
                    ON c.ProductId = p.ProductId
                    Where c.UserId = #session.User.UserId#
                </cfquery>

                <cfset itemsArray = [] />
                <cfloop query="itemsQuery">

                    <cfif IsNull(#DiscountedPrice#)>
                        <cfset dscnt = false />
                        <cfelse>
                        <cfset dscnt = true />
                    </cfif>

                    <cfset ArrayAppend(itemsArray, {
                           "id"    = #ProductId#,
                           "name"  = "#Name#",
                           "qty"   = #Qty#,
                           "price" = #ListPrice#,
                           "discount"  = #dscnt#,
                           "discountedPrice"   = #DiscountedPrice#
                           }) />
                </cfloop>
                <!--- SET the step 1 checkout variables inside session --->
                <cfset session.User.checkout.itemsInfo = #itemsArray#/>
        <cfcatch>
                <cfdump var="#cfcatch#" />
        </cfcatch>
        </cftry>

        <cfreturn #itemsArray#/>
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

</cfcomponent>
