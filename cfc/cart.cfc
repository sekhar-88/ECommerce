<cfcomponent>

    <cffunction  name="isCartEmpty" output="false" returntype="boolean"  returnFormat="json" access="remote">
        <cfif session.loggedin>
            <cfquery name="items">
                SELECT CartId
                FROM [Cart]
                WHERE UserId = #session.User.UserId#
            </cfquery>
            <cfif items.recordcount>
                <cfset result = "false"/>
                <cfelse>
                <cfset result = "true" />
            </cfif>
        <cfelse>
            <cfset result = ArrayIsEmpty(session.cart)/>
        </cfif>

        <cfreturn #result#/>
    </cffunction>

    <cffunction name="removeFromUserCart" output="true" returntype="boolean" returnformat="json" access="remote">
        <cfargument name="pid" type="numeric" required="true" />
        <cfset uid = #session.user.userid#/>
            <cftry>
                <cfquery name="removeItem">
                    DELETE
                    FROM [Cart]
                    WHERE ProductId = #arguments.pid# AND UserId = #uid#
                </cfquery>
                <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->
                <cfreturn true/>
            <cfcatch>
                <cfreturn false/>
            </cfcatch>
            </cftry>
    </cffunction>

    <cffunction name="removeFromSessionCart" output="false" returnType="boolean" returnFormat="json" access="remote" >
        <cfargument name="pid" type="numeric" required="true"/>
                <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->
                <cfreturn arrayDelete(session.cart, #arguments.pid#)/>
    </cffunction>

    <cffunction name="getCartCount" output="true" returnType="numeric" returnFormat="json" access="remote" >
        <cfif session.loggedin>
            <cfquery name="cartcount">
                SELECT COUNT(*) AS count from [Cart]
                Where UserId = #Session.User.UserId#
            </cfquery>
            <cfreturn #cartcount.count#/>
        <cfelse>
            <cfif StructKeyExists(session, "cart")>
                <cfreturn #ArrayLen(session.cart)#/>
            <cfelse>
                <cfreturn 0/>
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="getCartItems" returnformat="JSON" returntype="Array" access="remote" output="true">
        <cfset pList = []/>
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

            <!--- PRODUCT IN LOGGED USER'S CART --->
            <cfloop query="products">
                <cfset ArrayAppend(pList, {
                    "CartId" = "#products.CartId#",
                    "ProductId" = "#products.ProductId#",
                    "Name" = "#products.Name#",
                    "Qty" = "#products.Qty#",
                    "UserId" = "#products.UserId#",
                    "DiscountAmount" = "#products.DiscountAmount#",
                    "DiscountedPrice" = "#products.DiscountedPrice#"
                })/>
            </cfloop>

            <cfreturn pList/>
        <cfelse>  <!---NOT LOGGEDIN  --->
            <cftry>
                <cfif NOT ArrayIsEmpty(session.cart)>
                    <cfset cart_list = ArrayToList(session.cart)/>
                    <cfquery name="products">
                        SELECT p.ProductId, p.Name
                        FROM [Product] p
                        WHERE ProductId IN (   <cfqueryparam
                                                value = '#cart_list#'
                                                cfsqltype="cf_sql_integer"
                                                list = 'yes' >
                                           )
                    </cfquery>
                    <cfloop query="products">
                        <cfset ArrayAppend(pList, {
                                "ProductId" = #products.ProductId#,
                                "Name" = #products.Name#
                            })/>
                    </cfloop>
                    <cfreturn #pList#/>
                <cfelse>
                    <cfreturn #pList#/>
                </cfif>
            <cfcatch>
                <cfdump var="#cfcatch#" />
            </cfcatch>
            </cftry>
        </cfif>
    </cffunction>

</cfcomponent>
