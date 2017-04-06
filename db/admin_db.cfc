<cfcomponent>

    <cffunction name="queryBrands" returntype="Query" access = "public"  >
        <cfquery name="REQUEST.brands">
            SELECT BrandId, BrandName
            FROM [Brand]
        </cfquery>

        <cfreturn REQUEST.brands />
    </cffunction>

    <cffunction name="querySuppliers" returntype = "Query" access="public"  >

        <cfquery name="REQUEST.suppliers">
            SELECT *
            FROM [Supplier]
        </cfquery>

        <cfreturn REQUEST.suppliers />
    </cffunction>


    <cffunction name="queryProductsForSubCategory" returntype = "query" access = "public" >
        <cfargument name="scatid" type="numeric" required="true"  />

        <cfquery name="REQUEST.products">
            SELECT * from [Product]
            WHERE SubCategoryId = <cfqueryparam value="#ARGUMENTS.scatid#" cfsqltype="cf_sql_smallint">
        </cfquery>

        <cfreturn REQUEST.products />
    </cffunction>

    <cffunction name="insertSubCategory" returntype = "void" access = "public" >
        <cfargument name="categoryid" type="numeric" required="true" />
        <cfargument name="subcategoryname" type="string" required="true" />

        <cfquery name="insertNewSubcategory">
            INSERT INTO [ProductSubCategory]
                (SubCategoryName, CategoryId)
            VALUES
            (
                <cfqueryparam value="#ARGUMENTS.subcategoryname#" cfsqltype="cf_sql_nvarchar" />,
                <cfqueryparam value="#ARGUMENTS.categoryid#" cfsqltype="cf_sql_int" />
            )
        </cfquery>
    </cffunction>

    <cffunction name="insertBrand" returntype="void" access = "public"  >
        <cfargument name="brand" required="true" type="string"/>

        <cfquery name="REQUEST.insertBrand">
            INSERT INTO [Brand]
            (BrandName)
            VALUES
            (<cfqueryparam value="#arguments.brand#" cfsqltype="cf_sql_nvarchar" />)
        </cfquery>

    </cffunction>

    <cffunction name="insertCategory" returntype="void" access = "public"  >
        <cfargument name="categoryname" required="true" type="string" />

        <cfquery name="insertCategory">
            INSERT INTO [ProductCategory]
            (CategoryName)
            VALUES
            (<cfqueryparam value="#arguments.categoryname#" cfsqltype="cf_sql_nvarchar" />)
        </cfquery>
    </cffunction>


    <cffunction name="queryForCategory" returntype = "query" access = "public" >
        <cfquery name="REQUEST.categoryQuery">
            SELECT * FROM [ProductCategory] WHERE CategoryName = <cfqueryparam value="#ARGUMENTS.categoryname#" cfsqltype="cf_sql_nvarchar" />
        </cfquery>

        <cfreturn REQUEST.categoryQuery />
    </cffunction>

    <cffunction name="queryForSubCategory" returntype = "query" access = "public" >
        <cfquery name="REQUEST.subCategoryQuery">
            SELECT * FROM [ProductSubCategory] WHERE SubCategoryName = <cfqueryparam value="#ARGUMENTS.subcategoryname#" cfsqltype="cf_sql_nvarchar" />
        </cfquery>
        <cfreturn #REQUEST.subCategoryQuery# />
    </cffunction>

    <cffunction name="queryForBrand" returntype = "query" access = "public" >
        <cfquery name="REQUEST.brandQuery">
            SELECT *
            FROM [Brand]
            WHERE BrandName = <cfqueryparam value="#ARGUMENTS.brand#" cfsqltype="cf_sql_nvarchar" />
        </cfquery>
        <cfreturn #REQUEST.brandQuery# />
    </cffunction>

</cfcomponent>
