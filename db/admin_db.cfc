<cfcomponent>

    <cffunction name="queryBrands" returntype="Query" access = "public"  >
        <cftry>

            <cfquery name="LOCAL.brands">
                SELECT BrandId, BrandName
                FROM [Brand]
            </cfquery>

            <cfcatch type = "DATABASE">
                <cflog file = "#APPLICATION.db_logfile#" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
                <cfset LOCAL.response.message = "couldn't retrieve brands" />
            </cfcatch>
        </cftry>

        <cfreturn LOCAL.brands />
    </cffunction>

    <cffunction name="querySuppliers" returntype = "Struct" access="public"  >
        <cfset LOCAL.response = { "status" = "" } />
        <cftry >

            <cfquery name="LOCAL.suppliers">
                SELECT SupplierId, CompanyName, ContactPersonName, ContactNo, CourierId
                FROM [Supplier]
            </cfquery>

            <cfset LOCAL.response.result = LOCAL.suppliers />

            <cfcatch>
                <cflog file = "#APPLICATION.db_logfile#" text="message: #cfcatch.message# , NativeErrorCode: #cfcatch.nativeErrorCode#" type="error"  />
                <cfset LOCAL.response.status = "error" />
            </cfcatch>
        </cftry>

        <cfreturn LOCAL.response />
    </cffunction>


    <cffunction name="queryProductsForSubCategory" returntype = "query" access = "public" >
        <cfargument name="scatid" type="numeric" required="true"  />

        <cfquery name="LOCAL.products">
            SELECT * from [Product]
            WHERE SubCategoryId = <cfqueryparam value="#ARGUMENTS.scatid#" cfsqltype="cf_sql_smallint">
        </cfquery>

        <cfreturn LOCAL.products />
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

        <cfquery name="LOCAL.insertBrand">
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
        <cfquery name="LOCAL.categoryQuery">
            SELECT CategoryId, CategoryName
            FROM [ProductCategory]
            WHERE CategoryName = <cfqueryparam value="#ARGUMENTS.categoryname#" cfsqltype="cf_sql_nvarchar" />
        </cfquery>

        <cfreturn LOCAL.categoryQuery />
    </cffunction>

    <cffunction name="queryForSubCategory" returntype = "query" access = "public" >
        <cfquery name="LOCAL.subCategoryQuery">
            SELECT SubCategoryId, SubCategoryName, CategoryId
            FROM [ProductSubCategory]
            WHERE SubCategoryName = <cfqueryparam value="#ARGUMENTS.subcategoryname#" cfsqltype="cf_sql_nvarchar" />
        </cfquery>
        <cfreturn #LOCAL.subCategoryQuery# />
    </cffunction>

    <cffunction name="queryForBrand" returntype = "query" access = "public" >
        <cfquery name="LOCAL.brandQuery">
            SELECT BrandId, BrandName
            FROM [Brand]
            WHERE BrandName = <cfqueryparam value="#ARGUMENTS.brand#" cfsqltype="cf_sql_nvarchar" />
        </cfquery>
        <cfreturn #LOCAL.brandQuery# />
    </cffunction>

</cfcomponent>
