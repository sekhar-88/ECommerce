<cfcomponent>
    <cffunction name="getCategories" returntype="Query" access="remote" output="false" >
        <cfquery name="categories" cachedWithin="#CreateTimeSpan(0,0,10,0)#">
            Select *
            From [ProductCategory]
        </cfquery>
        <cfreturn #categories# />
    </cffunction>

    <cffunction name="getSubCategories" returntype="Query" output="false" >
        <cfargument name="CategoryId" type="numeric" required="true"  />
        <cfquery name="subcategories" cachedWithin="#createTimeSpan(0,0,10,0)#">
            Select SubCategoryId, SubCategoryName
            from [ProductSubCategory]
            WHERE CategoryId = #arguments.CategoryId#
        </cfquery>
        <cfreturn #subcategories# />
    </cffunction>
    <cffunction name="getSubCategoriesJSObject" returnType="any" returnFormat="json" access="remote" output="true">
        <cfargument name="categoryname" required="true" type="string"/>
        <cftry>
        <cfquery name="subcategories">
            SELECT psc.*
            from [ProductSubCategory] psc
            INNER JOIN [ProductCategory] pc
            ON psc.CategoryId = pc.CategoryId
            Where pc.CategoryName = <cfqueryparam value="#arguments.categoryname#" cfsqltype="cf_sql_char">
        </cfquery>
        <cfset subcategoryObject = {}/>
        <cfloop query="subcategories" >
            <cfset StructInsert(subcategoryObject, #SubCategoryId#, #subcategories.SubCategoryName#)/>
        </cfloop>
        <cfcatch>
            <cfdump var="#cfcatch#" />
        </cfcatch>
        </cftry>

        <cfreturn #subcategoryObject#/>
    </cffunction>
</cfcomponent>
