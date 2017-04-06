<cfcomponent>

    <!--- returns cart item details with their respective product names --->
    <cffunction name="queryProductsFromUserCart" returntype="query" access="public"   >
        <cfquery name="REQUEST.items">
                SELECT c.*,p.Name
                FROM [Cart] c
                INNER JOIN [Product] p
                ON c.ProductId = p.ProductId
                WHERE c.UserId = #SESSION.User.UserId#
        </cfquery>
        <cfreturn #REQUEST.items# />
    </cffunction>


    <cffunction name="queryProductsFromSessionCart" returntype="query" access="public"   >
        <cfset LOCAL.cart_list = ArrayToList(SESSION.cart) />

        <cfquery name="REQUEST.products">
            SELECT p.ProductId, p.Name
            FROM [Product] p
            WHERE p.ProductId IN (   <cfqueryparam
                                    value = '#LOCAL.cart_list#'
                                    cfsqltype="cf_sql_integer"
                                    list = 'yes' >
                               )
        </cfquery>

        <cfreturn #REQUEST.products# />
    </cffunction>


    <cffunction name="removeItemFromUserCart" returntype="void" access = "public" >
        <cfargument name="pid" type="numeric" required="true" />

        <cfquery name="removeItem">
            DELETE
            FROM [Cart]
            WHERE ProductId = #ARGUMENTS.pid# AND UserId = #SESSION.User.UserId#
        </cfquery>
    </cffunction>

</cfcomponent>
