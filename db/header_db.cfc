<cfcomponent>
    <cffunction name="getCategories" returntype="query" access="public"   >

        <cfquery name="REQUESt.categories">
            Select *
            From [ProductCategory]
        </cfquery>

        <cfreturn #REQUEST.categories# />
    </cffunction>


    <cffunction name="getSubCategories" returntype="query" access="public"   >
        <cfargument name="CategoryId" type="numeric" required="true"  />

        <cfquery name="REQUEST.subcategories">
            Select SubCategoryId, SubCategoryName
            from [ProductSubCategory]
            WHERE CategoryId = <cfqueryparam value="#ARGUMENTS.CategoryId#" cfsqltype="cf_sql_int" />
        </cfquery>

        <cfreturn #REQUEST.subcategories# />
    </cffunction>

    <cffunction name="getSubCategoriesFromCategoryName" returntype="query" access="public"   >
        <cfargument name="categoryname" required="true" type="string"/>

            <cfquery name="REQUEST.subcategories">
                SELECT psc.*
                from [ProductSubCategory] psc
                INNER JOIN [ProductCategory] pc
                ON psc.CategoryId = pc.CategoryId
                Where pc.CategoryName = <cfqueryparam value="#ARGUMENTS.categoryname#" cfsqltype="cf_sql_char">
            </cfquery>

        <cfreturn #REQUEST.subcategories#/>
        
    </cffunction>
</cfcomponent>
