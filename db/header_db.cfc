<cfcomponent>
    <cffunction name="getCategories" returntype="query" access="public"   >

        <cfquery name="LOCAL.categories">
            Select *
            From [ProductCategory]
        </cfquery>

        <cfreturn #LOCAL.categories# />
    </cffunction>


    <cffunction name="getSubCategories" returntype="query" access="public"   >
        <cfargument name="CategoryId" type="numeric" required="true"  />

        <cfquery name="LOCAL.subcategories">
            Select SubCategoryId, SubCategoryName
            from [ProductSubCategory]
            WHERE CategoryId = <cfqueryparam value="#ARGUMENTS.CategoryId#" cfsqltype="cf_sql_int" />
        </cfquery>

        <cfreturn #LOCAL.subcategories# />
    </cffunction>

    <cffunction name="getSubCategoriesFromCategoryName" returntype="query" access="public"   >
        <cfargument name="categoryname" required="true" type="string"/>

            <cfquery name="LOCAL.subcategories">
                SELECT psc.*
                from [ProductSubCategory] psc
                INNER JOIN [ProductCategory] pc
                ON psc.CategoryId = pc.CategoryId
                Where pc.CategoryName = <cfqueryparam value="#ARGUMENTS.categoryname#" cfsqltype="cf_sql_char">
            </cfquery>

        <cfreturn #LOCAL.subcategories#/>
        
    </cffunction>
</cfcomponent>
