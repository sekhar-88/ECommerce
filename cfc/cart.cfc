<cfcomponent extends="checkout" >
    <cfset VARIABLES.cartDB = CreateObject("db.cart_db") />

    <cffunction  name="isCartEmpty" output="false" returntype="boolean"  returnFormat="json" access="remote">
        <cfif session.loggedin>
            <cfset LOCAL.result = "false" />
            <cfset LOCAL.items = VARIABLES.cartDB.queryProductsFromUserCart() />
            <cfif NOT LOCAL.items.recordcount >   <cfset LOCAL.result = "true" />
            </cfif>
        <cfelse>
            <cfset LOCAL.result = ArrayIsEmpty(SESSION.cart) />
        </cfif>

        <cfreturn LOCAL.result />
    </cffunction>


<!--- removes Product from either session OR User Cart --->
    <cffunction name="removeFromCart" returnFormat = "JSON" returntype = "boolean" access="remote" >
        <cfargument name="pid" type="numeric" required = "true" />

        <cfif SESSION.loggedin>
            <cfset LOCAL.response = removeFromUserCart(pid) />
        <cfelse>
            <cfset LOCAL.response = removeFromSessionCart(pid) />
        </cfif>

        <cfreturn LOCAL.response />
    </cffunction>


    <cffunction name="removeFromUserCart" output="true" returntype="boolean" returnformat="json" access="remote">
        <cfargument name="pid" type="numeric" required="true" />

            <cftry >

                <cfset VARIABLES.cartDB.removeItemFromUserCart( argumentcollection = "#ARGUMENTS#" ) />
                <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->
                <cfset SESSION.User.paymentDataChanged = true />

                <cfcatch>
                    <cfdump var="#cfcatch#" />
                </cfcatch>

            </cftry>
            <cfreturn true/>
    </cffunction>


    <cffunction name="removeFromSessionCart" output="false" returnType="boolean" returnFormat="json" access="remote" >
        <cfargument name="pid" type="numeric" required="true"/>
                <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->

                <!--- for refreshing while placing order ..
                    to check if any new cart data is added or not ...
                    if payment data changed .. it will refresh the page..
                    if it is true
                    (this is set to false only when user clicks on proceed to payment section) --->
                <cfset SESSION.User.paymentDataChanged = true />


                <cfreturn arrayDelete(session.cart, #arguments.pid#)/>
    </cffunction>


<!---
    both for USER & SESSION CART
 --->
    <cffunction name="getCartCount" output="true" returnType="numeric" returnFormat="json" access="remote" >

        <cfif session.loggedin>

            <cfset LOCAL.items = VARIABLES.cartDB.queryProductsFromUserCart() />
            <cfreturn #LOCAL.items.recordCount#/>

        <cfelse>
            <cfif StructKeyExists(session, "cart")>
                <cfreturn #ArrayLen(session.cart)#/>
            <cfelse>
                <cfreturn 0/>
            </cfif>
        </cfif>
    </cffunction>


<!---
    returntype array for Session Cart
    returntype query for User Cart
    may not being used
 --->
    <cffunction name="getCartItems" returnformat="JSON" returntype="Any" access="remote" output="true">
        <cfset LOCAL.pList = []/>

        <cfif session.loggedin>     <cfset LOCAL.pList = getUserCartItems() />
        <cfelse>                    <cfset LOCAL.pList = getSessionCartItems() />
        </cfif>

        <cfreturn LOCAL.pList />
    </cffunction>


    <!--- PRODUCT IN LOGGED USERS CART --->
    <cffunction name="getUserCartItems" returntype="Query" access = "private" >
        <cfset LOCAL.pList = [] />

        <cfset LOCAL.products = VARIABLES.cartDB.queryProductsFromUserCart() />
        <cfreturn LOCAL.products />
    </cffunction>


    <!--- PRODUCT IN SESSION CART --->
    <cffunction name="getSessionCartItems" returntype="Array" access = "private" >
        <cfset LOCAL.pList = [] />
        <cfif NOT ArrayIsEmpty(session.cart)>

            <cfset LOCAL.products = VARIABLES.cartDB.queryProductsFromSessionCart() />

            <cfloop query="LOCAL.products">
                <cfset ArrayAppend(LOCAL.pList, {
                        "ProductId" = #ProductId#,
                        "Name" = #Name#
                    })/>
            </cfloop>
        </cfif>

        <cfreturn #LOCAL.pList# />
    </cffunction>
</cfcomponent>
