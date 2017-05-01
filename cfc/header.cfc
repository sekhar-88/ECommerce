<!---
    Controller name: header.cfc
    contains functaionalities of header part of the page.
--->

<cfcomponent>
    <cfset VARIABLES.headerDB = CreateObject("db.header_db") />

    <!--- for populating the header section --->
    <cffunction name="getCategories" returntype="Query" access="remote" output="false" >
        <cfset LOCAL.categories = VARIABLES.headerDB.getCategories( argumentcollection = "#ARGUMENTS#" ) />

        <cfreturn LOCAL.categories />
    </cffunction>


    <!--- for populating the header section --->
    <cffunction name="getSubCategories" returntype="Query" output="false" >
        <cfargument name="CategoryId" type="numeric" required="true"  />

        <cfset LOCAL.subcategories = VARIABLES.headerDB.getSubCategories( CategoryId = #ARGUMENTS.CategoryId# ) />
        <cfreturn LOCAL.subcategories />
    </cffunction>


    <!--- for setting the filter categories --->
    <cffunction name="getSubCategoriesJSObject" returnType="any" returnFormat="json" access="remote" output="true">
        <cfargument name="categoryname" required="true" type="string"/>

        <!--- get subcategories from db layer --->
        <cfset LOCAL.querySubcategories = VARIABLES.headerDB.getSubCategoriesFromCategoryName( argumentcollection="#ARGUMENTS#" ) />

            <cfset LOCAL.subCategoryObject = {} />

            <cfloop query="LOCAL.querySubcategories" >
                <cfset StructInsert(subCategoryObject, #SubCategoryId#, #SubCategoryName#)/>
            </cfloop>

        <cfreturn #LOCAL.subCategoryObject# />
    </cffunction>
</cfcomponent>
