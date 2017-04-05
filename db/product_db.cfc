<!--- This database layer handles all the calls to Dabatase related actions which relates in anyway to the products management
like adding to cart removing from cart, editing updating product details etc. --->

<!--- all the functions have return type is either VOID or QUERY --->

<cfcomponent>

    <cffunction name = "insertIntoCart" access = "public" returntype = "void" >

        <cfargument name = "pid" type = "numeric" required = "true" />
        <cfargument name = "price" type = "numeric" required = "true" />

        <cfquery name = "insetToCart">
            INSERT INTO [Cart]
            ( ProductId, Qty, UserId, TotalPrice)
            VALUES
            ( <cfqueryparam value = "#arguments.pid#" cfsqltype = "cf_sql_integer">, 1, #session.User.UserId#, #ARGUMENTS.price# )
        </cfquery>

        <cfreturn />
    </cffunction>



    <cffunction name = "queryCartForProduct" returntype = "query" access = "public" >
        <cfargument name = "pid" type = "numeric" required = "true" />

        <cfquery name = "REQUEST.cart">
            select CartId
            from [Cart]
            Where ProductId= < cfqueryparam value = "#ARGUMENTS.pid#" cfsqltype = "cf_sql_bigint" >  AND UserId = #Session.User.UserId#
        </cfquery>

        <cfreturn #REQUEST.cart# />
    </cffunction>


    <cffunction name = "queryProductsForSubCategory" returntype = "query" access = "public" >
        <cfargument name = "scat" required = "true" type = "numeric" output = "false" />

        <cfquery name = "REQUEST.products" >
            SELECT *
            FROM [Product]
            WHERE SubCategoryId = <cfqueryparam value = "#ARGUMENTS.scat#" CFSQLType = "[cf_sql_integer]">
        </cfquery>

        <cfreturn #REQUEST.products# />
    </cffunction>


    <cffunction name = "getProduct" returntype = "query" access = "public" >
        <cfargument name = "pid" type = "numeric" required = "true">

        <cfquery name = "REQUEST.productItem">
            SELECT *
            FROM [Product]
            WHERE ProductId = <cfqueryparam value = "#ARGUMENTS.pid#" cfsqltype = "cf_sql_bigint" />
        </cfquery>

        <cfreturn #REQUEST.productItem#/>
    </cffunction>


    <cffunction name = "queryProductDetailsAndBrand" returntype = "query" access = "public" >
        <cfargument name = "pid" required = "true" type = "numeric" />

            <cfquery name = "REQUEST.productDetails">
                SELECT p.* , b.BrandName
                FROM [Product] p
                INNER JOIN [Brand] b
                ON p.BrandId = b.BrandId
                WHERE p.ProductId = <cfqueryparam value = "#pid#" CFSQLType = "[cf_sql_integer]">
            </cfquery>


        <cfreturn #REQUEST.productDetails# />
    </cffunction>

</cfcomponent>
