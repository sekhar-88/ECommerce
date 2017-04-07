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
                WHERE p.ProductId = #ARGUMENTS.pid#
                <!--- <cfqueryparam value = "#ARGUMENTS.pid#" CFSQLType = "[cf_sql_integer]"> --->
            </cfquery>


        <cfreturn #REQUEST.productDetails# />
    </cffunction>


    <cffunction name="getSubCategoryFilters" returntype = "Query" access="public"  >
        <cfargument name="q" type = "string" required = "true" />

        <cftry>
            <cfquery name="REQUEST.subCategoryFilters">
                SELECT DISTINCT psc.SubCategoryName, psc.SubCategoryId
                FROM [ProductSubCategory] psc
                INNER JOIN [Product] p
                ON psc.SubCategoryId = p.SubCategoryId
                WHERE p.Name LIKE <cfqueryparam value = "%#URL.q#%" cfsqltype="CF_SQL_CHAR">
            </cfquery>

            <cfcatch>
                <cfdump var="#cfcatch#" />
                <cfabort />
            </cfcatch>

        </cftry>
        <cfreturn REQUEST.subCategoryFilters />
    </cffunction>


    <cffunction name="getBrandsFilter" returntype = "Query" access = "public" >
        <cfargument name="scat" type = "string" required = "true" />

        <cfquery name="REQUEST.brandsFilter">
            SELECT DISTINCT b.BrandName , b.BrandId
            FROM [Brand] b
            INNER JOIN [Product] p
            ON b.BrandId = p.BrandId
            WHERE p.SubCategoryId = <cfqueryparam value="#ARGUMENTS.scat#" cfsqltype="cf_sql_int" />
        </cfquery>

        <cfreturn REQUEST.brandsFilter />
    </cffunction>


    <cffunction name="queryProducts" returntype = "query" access = "public" >
        <cfargument name="q" required="true" type = "string"  />

        <cfquery name = "REQUEST.productsQuery">
            select *
              from [Product]
             where Name LIKE <cfqueryparam value="%#ARGUMENTS.q#%" cfsqltype="cf_sql_char" >
        </cfquery>

        <cfreturn REQUEST.productsQuery />
    </cffunction>

    <cffunction name="addNewProductToDB" returntype="boolean" access = "public" >
        <cfargument name="form" type="struct" required = "true"         />
        <cfargument name="imageName" type = "string" required = "true"  />

        <cfquery name="insertProduct">
            INSERT INTO [Product]
            (Name, BrandId, SubCategoryId, SupplierId, ListPrice, Qty, Description, Image)
            VALUES
            (
                <cfqueryparam value="#ARGUMENTS.form.Name#" cfsqltype="cf_sql_char" >,
                <cfqueryparam value="#ARGUMENTS.form.BrandId#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.SubCategoryId#" CFSQLType = "cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.SupplierId#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.ListPrice#" cfsqltype="cf_sql_bigint" >,
                <cfqueryparam value="#ARGUMENTS.form.Qty#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.Description#" cfsqltype="CF_SQL_NVARCHAR" >,
                <cfqueryparam value="#ARGUMENTS.imageName#" cfsqltype="cf_sql_nvarchar">
            )
        </cfquery>

        <cfreturn true />
    </cffunction>
</cfcomponent>
