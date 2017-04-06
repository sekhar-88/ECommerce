<cfcomponent>
    <cfset VARIABLES.headerDB = CreateObject("db.header_db") />

    <!--- for populating the header section --->
    <cffunction name="getCategories" returntype="Query" access="remote" output="false" >
        <cfinvoke method="getCategories" component="#VARIABLES.headerDB#"
            returnvariable="LOCAL.categories" argumentcollection = "#ARGUMENTS#" />

        <cfreturn #LOCAL.categories# />
    </cffunction>


    <!--- for populating the header section --->
    <cffunction name="getSubCategories" returntype="Query" output="false" >
        <cfargument name="CategoryId" type="numeric" required="true"  />

        <cfinvoke method="getSubCategories" component="#VARIABLES.headerDB#"
            returnvariable = "REQUEST.subcategories" argumentcollection="#ARGUMENTS#" />

        <cfreturn #REQUEST.subcategories# />
    </cffunction>


    <!--- for setting the filter categories --->
    <cffunction name="getSubCategoriesJSObject" returnType="any" returnFormat="json" access="remote" output="true">
        <cfargument name="categoryname" required="true" type="string"/>

        <!--- get subcategories from db layer --->
        <cfinvoke method="getSubCategoriesFromCategoryName" component="#VARIABLES.headerDB#"
            returnvariable="LOCAL.querySubcategories" argumentcollection="#ARGUMENTS#"  />

            <cfset LOCAL.subCategoryObject = {} />

            <cfloop query="LOCAL.querySubcategories" >
                <cfset StructInsert(subCategoryObject, #SubCategoryId#, #SubCategoryName#)/>
            </cfloop>

        <cfreturn #LOCAL.subCategoryObject# />
    </cffunction>
</cfcomponent>
