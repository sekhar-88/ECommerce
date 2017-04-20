<!--- This database layer handles all the calls to Dabatase related actions which relates in anyway to the products management
like adding to cart removing from cart, editing updating product details etc. --->


<cfcomponent>

    <!--- get all products for Category only --->
    <cffunction name="getProductsByCategory">
        <!---
         this function will send all products list to the useer Products page if there is NO
         subcategory defined in URL
         all products in the category will be shown
         ...To be worked on...
        --->
    </cffunction>


<!--- updates the product details from editing the product in product details page --->
    <cffunction name="updateProductDetails">
        <cfargument name="productUpdate" type="struct" required = "true"  />
        <cfargument name="imagename" type="string" required = "true" />

        <cfquery name="LOCAL.updateDetails">
            UPDATE [Product]
            SET Qty         =  <cfqueryparam value="#ARGUMENTS.productUpdate.Qty#" cfsqltype="cf_sql_int" />,
                ListPrice   =  <cfqueryparam value="#ARGUMENTS.productUpdate.ListPrice#" cfsqltype="CF_SQL_BIGINT" />,
                Description =  <cfqueryparam value="#ARGUMENTS.productUpdate.Description#" cfsqltype="CF_SQL_NVARCHAR" />,
                Image = <cfqueryparam value="#imagename#" cfsqltype="CF_SQL_NVARCHAR" />,
                ModifiedDate = GETDATE()
                <!--- for discount --->
                <!--- <cfif ARGUMENTS.productUpdate.DiscountPercent NEQ 0 >
                    , DiscountPercent = <cfqueryparam value="#ARGUMENTS.productUpdate.DiscountPercent#" cfsqltype="cf_sql_int" />
                </cfif> --->
            WHERE ProductId = #ARGUMENTS.productUpdate.ProductId#
        </cfquery>

        <cfreturn true />
    </cffunction>

<!---
    Add product to Cart FOR Logged in User
 --->
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


<!--- check if a product is in cart or not --->
    <cffunction name = "queryCartForProduct" returntype = "query" access = "public" >
        <cfargument name = "pid" type = "numeric" required = "true" />

        <cfquery name = "LOCAL.cart">
            select CartId
            from [Cart]
            Where ProductId= < cfqueryparam value = "#ARGUMENTS.pid#" cfsqltype = "cf_sql_bigint" >  AND UserId = #Session.User.UserId#
        </cfquery>

        <cfreturn #LOCAL.cart# />
    </cffunction>


<!---
    fetches products list
    gets products for given subcategory in products page
 --->
    <cffunction name = "queryProductsForSubCategory" returntype = "query" access = "public" >
        <cfargument name = "scat" required = "true" type = "numeric" output = "false" />

        <cfquery name = "LOCAL.products" >
            SELECT  ProductId, Name, BrandId, SubCategoryid, ListPrice, SupplierId,
                    DiscontinuedDate, DiscountPercent, DiscountedPrice, Qty,
                    Description, Image
            FROM [Product]
            WHERE SubCategoryId = <cfqueryparam value = "#ARGUMENTS.scat#" CFSQLType = "[cf_sql_integer]">
                    AND DiscontinuedDate IS NULL
        </cfquery>

        <cfreturn #LOCAL.products# />
    </cffunction>

<!--- get product details from give Product Id --->
    <cffunction name = "getProduct" returntype = "query" access = "public" >
        <cfargument name = "pid" type = "numeric" required = "true">

        <cfquery name = "LOCAL.productItem">
            SELECT [ProductId], [Name], [BrandId], [SubCategoryId], [Weight], [ListPrice], [SupplierId], [DiscontinuedDate], [DiscountPercent], [DiscountedPrice], [Qty], [Description], [Image]
            FROM [Product]
            WHERE ProductId = <cfqueryparam value = "#ARGUMENTS.pid#" cfsqltype = "cf_sql_bigint" />
        </cfquery>

        <cfreturn #LOCAL.productItem#/>
    </cffunction>


    <cffunction name = "queryProductDetailsAndBrand" returntype = "query" access = "public" >
        <cfargument name = "pid" required = "true" type = "numeric" />

            <cfquery name = "LOCAL.productDetails" >
                SELECT p.[ProductId], p.[Name], p.[BrandId], p.[SubCategoryId], p.[Weight], p.[ListPrice], p.[SupplierId], p.[DiscontinuedDate], p.[DiscountPercent], p.[DiscountedPrice], p.[Qty], p.[Description], p.[Image] , b.BrandName
                FROM [Product] p
                INNER JOIN [Brand] b
                ON p.BrandId = b.BrandId
                WHERE p.ProductId = #ARGUMENTS.pid# AND p.DiscontinuedDate IS NULL
                <!--- <cfqueryparam value = "#ARGUMENTS.pid#" CFSQLType = "[cf_sql_integer]"> --->
            </cfquery>


        <cfreturn #LOCAL.productDetails# />
    </cffunction>


    <cffunction name="getSubCategoryFilters" returntype = "Query" access="public"  >
        <cfargument name="q" type = "string" required = "true" />

        <cftry>
            <cfquery name="LOCAL.subCategoryFilters">
                SELECT DISTINCT psc.SubCategoryName, psc.SubCategoryId
                FROM [ProductSubCategory] psc
                INNER JOIN [Product] p
                ON psc.SubCategoryId = p.SubCategoryId
                WHERE p.Name LIKE <cfqueryparam value = "%#URL.q#%" cfsqltype="CF_SQL_CHAR">
            </cfquery>

            <cfcatch>
                <cflog file = "ShoppingDBlog" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />

            </cfcatch>

        </cftry>
        <cfreturn LOCAL.subCategoryFilters />
    </cffunction>


    <cffunction name="getBrandsFilter" returntype = "Query" access = "public" >
        <cfargument name="scat" type = "string" required = "true" />

        <cfquery name="LOCAL.brandsFilter">
            SELECT DISTINCT b.BrandName , b.BrandId
            FROM [Brand] b
            INNER JOIN [Product] p
            ON b.BrandId = p.BrandId
            WHERE p.SubCategoryId = <cfqueryparam value="#ARGUMENTS.scat#" cfsqltype="cf_sql_int" />
        </cfquery>

        <cfreturn LOCAL.brandsFilter />
    </cffunction>

<!--- query products from product Name --->
    <cffunction name="queryProducts" returntype = "query" access = "public" >
        <cfargument name="q" required="true" type = "string"  />

        <cfquery name = "LOCAL.productsQuery">
            select [ProductId], [Name], [BrandId], [SubCategoryId], [Weight], [ListPrice], [SupplierId], [DiscontinuedDate], [DiscountPercent], [DiscountedPrice], [Qty], [Description], [Image]
              from [Product]
             where Name LIKE <cfqueryparam value="%#ARGUMENTS.q#%" cfsqltype="cf_sql_char" >
        </cfquery>

        <cfreturn LOCAL.productsQuery />
    </cffunction>

    <cffunction name="addNewProductToDB" returntype="boolean" access = "public" >
        <cfargument name="form" type="struct" required = "true"         />
        <cfargument name="imageName" type = "string" required = "true"  />

        <cfquery name="insertProduct">
            INSERT INTO [Product]
            ( Name, BrandId, SubCategoryId, SupplierId, ListPrice, Qty, Description, Image, AdditionDate )
            VALUES
            (
                <cfqueryparam value="#ARGUMENTS.form.Name#" cfsqltype="cf_sql_char" >,
                <cfqueryparam value="#ARGUMENTS.form.BrandId#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.SubCategoryId#" CFSQLType = "cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.SupplierId#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.ListPrice#" cfsqltype="cf_sql_bigint" >,
                <cfqueryparam value="#ARGUMENTS.form.Qty#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#ARGUMENTS.form.Description#" cfsqltype="CF_SQL_NVARCHAR" >,
                <cfqueryparam value="#ARGUMENTS.imageName#" cfsqltype="cf_sql_nvarchar">,
                GETDATE()
            )
        </cfquery>

        <cfreturn true />
    </cffunction>


<!---
    get subcategory details  from given product id
--->
    <cffunction name="getSCategoryDetailsForProductId" returntype="Query" access = "public" >
        <cfargument name="pid" type = "numeric" required = "true" />

        <cftry>

            <cfquery name = "LOCAL.categoryDetails">
                SELECT p.SubCategoryId, psc.SubCategoryName, pc.CategoryId, pc.CategoryName
                FROM [Product] p
                INNER JOIN [ProductSubCategory] psc
                    ON p.SubCategoryId = psc.SubCategoryId
                INNER JOIN [ProductCategory] pc
                    ON pc.CategoryId = psc.CategoryId
                WHERE p.ProductId = <cfqueryparam value="#ARGUMENTS.pid#" cfsqltype="cf_sql_bigint" />
            </cfquery>

            <cfcatch type = "DATABASE">
                <cflog text="error while retrieving category details for a productid, message: #cfcatch.message#, errorcode: #cfcatch.errorCode# detail: #cfcatch.detail#" file="ShoppingDBlog" />
            </cfcatch>
        </cftry>

        <cfreturn LOCAL.categoryDetails />
    </cffunction>

<!--- simple function to fetch category name from the Subcategory ID --->
    <cffunction name="getSubCategoryName" returntype = "Query" access="public" >
        <cfargument name="scat" type="numeric" required = "true" />

        <cfquery name="LOCAL.subCategory">
            SELECT SubCategoryName, SubCategoryId
            FROM [ProductSubCategory]
            WHERE SubCategoryId = <cfqueryparam value="#ARGUMENTS.scat#" cfsqltype="cf_sql_int">
        </cfquery>

        <cfreturn LOCAL.subCategory />
    </cffunction>

    <cffunction name="queryExistingProductByName" returntype="boolean" access = "remote" output="true" >
        <cfargument name="name" type="string" required="true" />
        <cfset LOCAL.response = true />

        <cftry>
            <cfquery name="LOCAL.ProductExists">
                SELECT ProductId
                FROM [Product]
                WHERE Name = <cfqueryparam value="#ARGUMENTS.name#" cfsqltype="CF_SQL_NVARCHAR" />
            </cfquery>

            <cfcatch>
                <cflog file = "ShoppingDBlog" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
            </cfcatch>
        </cftry>

        <cfif LOCAL.ProductExists.recordCount>
                    <cfset LOCAL.response = true />
        <cfelse>    <cfset LOCAL.response = false />
        </cfif>

        <cfreturn LOCAL.response />
    </cffunction>


    <cffunction name="getProductImage" returntype = "String" access = "public" >
        <cfargument name="pid" type="numeric" required = "true" />
        <cftry>
            <cfquery name="LOCAL.ImageColumn">
                SELECT Image
                FROM [Product]
                WHERE ProductId = <cfqueryparam value = "#ARGUMENTS.pid#" cfsqltype="cf_sql_bigint" />
            </cfquery>
            <cfcatch type="database">
                <cflog file = "ShoppingDBlog" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
                <cfabort />
            </cfcatch>
        </cftry>

        <cfreturn #LOCAL.ImageColumn.Image# />
    </cffunction>
<!---
    THIS TRIES TO DELETE PRODUCT FROM DATABASE IF NO CONNECTION OF THE PRODUCT
    WITH ANY OTHER TABLE EXISTS ... RETURNS TRUE
    ELSE RETURNS FALSE FROM CATCH BLOCK
--->
    <cffunction name="deleteProductFromDB" returntype="boolean" access = "public" output="true">
        <cfargument name="pid" type="numeric" required = "true" />

        <cfset LOCAL.response = false />

        <!--- not deleting the product jsut mark it as discontinued --->
<!---
        <cftry>
            <!--- get image of the product --->
            <cfset LOCAL.Image = getProductImage(#ARGUMENTS.pid#) />

            <!--- delete product from db --->
            <cfquery name="LOCAL.deleteProduct">
                DELETE
                FROM [Product]
                WHERE ProductId = <cfqueryparam value = "#ARGUMENTS.pid#" cfsqltype="cf_sql_bigint" />
            </cfquery>

            <!--- delete it's image --->
            <cffile action="Delete"
                    file= "#APPLICATION.imagePath#\#LOCAL.Image#"
                    />
            <cfset LOCAL.response = true />

            <cfcatch >
                <cflog file = "ShoppingDBlog" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
                <cfset LOCAL.response = false />
            </cfcatch>

        </cftry>
 --->
        <cfreturn LOCAL.response />
    </cffunction>


    <!--- marks a product as discontinued  --->
    <cffunction name="markAsDiscontinuedInDB" returntype="boolean" access = "public"  >
        <cfargument name="pid" type = "numeric" requried = "true" />
        <cfset LOCAL.response = false />

        <cftry>
            <cfquery>
                UPDATE [Product]
                SET DiscontinuedDate = GETDATE()
                WHERE ProductId = <cfqueryparam value="#ARGUMENTS.pid#"/>
            </cfquery>
            <cfset LOCAL.response = true />
            <cfcatch type="database">
                <cflog file = "ShoppingDBlog" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
                <cfset LOCAL.response = false />
            </cfcatch>
        </cftry>

        <cfreturn LOCAL.response />
    </cffunction>


    <!---
        THIS function Queryies the Products Table Along with the provided filters
        returns QUery Obj String
    --->
    <cffunction name="queryProductsWithFilters" returntype="Struct" access = "public" output="true">
        <cfargument name="scat" required = "false" type= "numeric" default = "" />
        <cfargument name="brandid" required = "false" type="numeric" default = "" />
        <cfargument name="pricemin" required = "false" type = "numeric" default = "" />
        <cfargument name="pricemax" required = "false" type = "numeric" default = "" />

        <cfset LOCAL.response = {} />
        <cftry>

            <cfquery name = "LOCAL.productsQuery">
                SELECT [ProductId], [Name], [BrandId], [SubCategoryId], [Weight], [ListPrice], [SupplierId], [DiscontinuedDate], [DiscountPercent], [DiscountedPrice], [Qty], [Description], [Image]
                  FROM [Product]
                 WHERE SubCategoryId = <cfqueryparam value="#ARGUMENTS.scat#" cfsqltype="cf_sql_bigint" >
                        AND DiscontinuedDate IS NULL
                        <cfif ARGUMENTS.brandid NEQ -1 >
                            AND BrandId = #ARGUMENTS.brandid#
                        </cfif>

            </cfquery>


            <cfset LOCAL.response.status = "success" />
            <cfset LOCAL.response.result = [] />

            <cfloop query="#LOCAL.productsQuery#" >
                <cfset ArrayAppend(LOCAL.response.result, {
                        "ProductId"     = #LOCAL.productsQuery.ProductId# ,
                        "Name"          = #LOCAL.productsQuery.Name# ,
                        "BrandId"       = #LOCAL.productsQuery.BrandId# ,
                        "SubCategoryId" = #LOCAL.productsQuery.SubCategoryId# ,
                        "Weight"        = #LOCAL.productsQuery.Weight# ,
                        "ListPrice"     = #LOCAL.productsQuery.ListPrice# ,
                        "SupplierId"    = #LOCAL.productsQuery.SupplierId# ,
                        "DiscontinuedDate"  = #LOCAL.productsQuery.DiscontinuedDate# ,
                        "DiscountPercent"   = #LOCAL.productsQuery.DiscountPercent# ,
                        "DiscountedPrice"   = #LOCAL.productsQuery.DiscountedPrice# ,
                        "Qty"           = #LOCAL.productsQuery.Qty# ,
                        "Description"   = #LOCAL.productsQuery.Description# ,
                        "Image"         = #LOCAL.productsQuery.Image#
                    }) />
            </cfloop>

            <cfcatch type="DATABASE">
                <cflog file = "ShoppingDBlog" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
                <cfset LOCAL.response.status = "error"/>
                <cfset LOCAL.response.error = {} />
                <cfset LOCAL.response.error.message = "#cfcatch.message#" />
                <cfset LOCAL.response.error.details = "#cfcatch.detail#" />
                <cfdump var="#cfcatch#" />
                <cfreturn LOCAL.response />
            </cfcatch>
        </cftry>

        <cfreturn LOCAL.response />
    </cffunction>

</cfcomponent>
