<cfcomponent>
    <cfset VARIABLES.cartDB = CreateObject("db.cart_db") />

    <cffunction  name="isCartEmpty" output="false" returntype="boolean"  returnFormat="json" access="remote">
        <cfif session.loggedin>
            <cfset LOCAL.result = "false" />
            <cfinvoke method="queryProductsFromUserCart" component="#VARIABLES.cartDB#"
                returnvariable="REQUEST.items" />
            <cfif NOT REQUEST.items.recordcount >   <cfset LOCAL.result = "true" />
            </cfif>
        <cfelse>
            <cfset LOCAL.result = ArrayIsEmpty(session.cart) />
        </cfif>

        <cfreturn #LOCAL.result#/>
    </cffunction>


    <cffunction name="removeFromUserCart" output="true" returntype="boolean" returnformat="json" access="remote">
        <cfargument name="pid" type="numeric" required="true" />

            <cfinvoke method="removeItemFromUserCart" component="#VARIABLES.cartDB#"
                argumentcollection="#ARGUMENTS#" />

            <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->

            <cfreturn true/>
    </cffunction>


    <cffunction name="removeFromSessionCart" output="false" returnType="boolean" returnFormat="json" access="remote" >
        <cfargument name="pid" type="numeric" required="true"/>
                <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->
                <cfreturn arrayDelete(session.cart, #arguments.pid#)/>
    </cffunction>



    <cffunction name="getCartCount" output="true" returnType="numeric" returnFormat="json" access="remote" >
        <cfif session.loggedin>

            <cfinvoke method="queryProductsFromUserCart" component="#VARIABLES.cartDB#"
                returnvariable="REQUEST.items" />

            <cfreturn #REQUEST.items.recordCount#/>

        <cfelse>
            <cfif StructKeyExists(session, "cart")>
                <cfreturn #ArrayLen(session.cart)#/>
            <cfelse>
                <cfreturn 0/>
            </cfif>
        </cfif>
    </cffunction>


    <cffunction name="getCartItems" returnformat="JSON" returntype="Array" access="remote" output="true">
        <cfset LOCAL.pList = []/>

        <cfif session.loggedin>     <cfset LOCAL.pList = getUserCartItems() />

            <cfelse>  <!---NOT LOGGEDIN  --->
            <cfset LOCAL.pList = getSessionCartItems() />
        </cfif>

        <cfreturn #LOCAL.pList#/>
    </cffunction>


    <!--- PRODUCT IN LOGGED USERS CART --->
    <cffunction name="getUserCartItems" returntype="Array" access = "private" >
        <cfset LOCAL.pList = [] />

        <cfinvoke method="queryProductsFromUserCart" component="#VARIABLES.cartDB#"
            returnvariable="REQUEST.products" />

        <cfloop query="REQUEST.products">
            <cfset ArrayAppend(LOCAL.pList, {
                "CartId"      = "#CartId#",
                "ProductId"   = "#ProductId#",
                "Name"        = "#Name#",
                "Qty"         = "#Qty#",
                "UserId"      = "#UserId#",
                "DiscountAmount"  = "#DiscountAmount#",
                "DiscountedPrice" = "#DiscountedPrice#"
            })/>
        </cfloop>

        <cfreturn #LOCAL.pList# />
    </cffunction>


    <!--- PRODUCT IN SESSION CART --->
    <cffunction name="getSessionCartItems" returntype="Array" access = "private" >
        <cfset LOCAL.pList = [] />
        <cfif NOT ArrayIsEmpty(session.cart)>

            <cfinvoke method="queryProductsFromSessionCart" component="#VARIABLES.cartDB#"
                returnvariable="REQUEST.products" />

            <cfloop query="REQUEST.products">
                <cfset ArrayAppend(LOCAL.pList, {
                        "ProductId" = #ProductId#,
                        "Name" = #Name#
                    })/>
            </cfloop>
        </cfif>

        <cfreturn #LOCAL.pList# />
    </cffunction>
</cfcomponent>
