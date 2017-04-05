<!--- This database layer handles all the calls to Dabatase related actions which relates in anyway to the products management
like adding to cart removing from cart, editing updating product details etc. --->

<!--- all the functions have return type is either VOID or QUERY --->

<cfcomponent>

    <cffunction name="insertIntoCart"
        access="public"
        returntype="void" >

        <cfargument name = "pid"
            type = "numeric"
            required = "true"
            />
        <cfargument name = "price"
            type = "numeric"
            required = "true"
            />

        <cfquery name="insetToCart">
            INSERT INTO [Cart]
            (ProductId,Qty,UserId, TotalPrice)
            VALUES
            (<cfqueryparam value="#arguments.pid#" cfsqltype="cf_sql_integer">, 1, #session.User.UserId#, #ARGUMENTS.price#)
        </cfquery>

        <cfreturn />
    </cffunction>



    <cffunction name="isProductInCart"
        returntype="boolean"
        access = "public" >

        <cfargument name="pid"
            type="numeric"
            required = "true"
            />

        <cfquery name="cart">
            select CartId
            from [Cart]
            Where ProductId= < cfqueryparam value="#ARGUMENTS.pid#" cfsqltype="cf_sql_bigint" >  AND UserId = #Session.User.UserId#
        </cfquery>

        <cfset response = false />

        <cfif cart.recordCount> <cfset response = true/>
        <cfelse>                <cfset response = false/>
        </cfif>

        <cfreturn #response#/>
    </cffunction>


    <cffunction name="queryProductsForSubCategory"
        returntype = "query"
        access = "public" >

        <cfargument name = "scat"
            required = "true"
            type = "numeric"
            output = "false"
            />

        <cfquery name="products" >
            SELECT *
            FROM [Product]
            WHERE SubCategoryId = <cfqueryparam value = "#ARGUMENTS.scat#" CFSQLType = "[cf_sql_integer]">
        </cfquery>

        <cfreturn #products# />
    </cffunction>

    <cffunction name="getProductPrice"
        returntype="numeric"
        access = "public" >

        <!--- VARIABLES --->
        <cfset LOCAL.productPrice = 0 />

        <cfquery name = "REQUEST.price">
            SELECT ListPrice
            FROM [Product]
            WHERE ProductId = <cfqueryparam value = "#arguments.pid#" cfsqltype = "cf_sql_bigint" />
        </cfquery>
        <cfset LOCAL.productPrice = #REQUEST.Price.ListPrice#/>

        <cfreturn #LOCAL.productPrice#/>
    </cffunction>


    <cffunction name="queryProductDetails"
        returntype = "query"
        access = "public" >

        <cfargument name = "pid"
            required = "true"
            type = "numeric"
            />

        <cftry>
            <cfquery name="REQUEST.productDetails">
                SELECT p.* , b.BrandName
                FROM [Product] p
                INNER JOIN [Brand] b
                ON p.BrandId = b.BrandId
                WHERE p.ProductId = <cfqueryparam value = "#pid#" CFSQLType = "[cf_sql_integer]">
            </cfquery>

        <cfcatch>
            <cfdump var="#cfcatch#" />
            <cfabort />
        </cfcatch>
        </cftry>

        <cfreturn #REQUEST.productDetails# />
    </cffunction>

</cfcomponent>
