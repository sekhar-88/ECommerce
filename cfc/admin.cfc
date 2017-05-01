<!---
    Controller name: admin.cfc
    contains all admin related functions
--->


<!--- THE return response is structure containing function run status & result --->
<cfcomponent extends = "header" >
    <cfset VARIABLES.adminDB = CreateObject("db.admin_db") />

    <cffunction name = "getBrands" access = "remote" returnType = "any" returnFormat = "json" >
        <cfset LOCAL.brandlist = {}/>

        <cfset LOCAL.brands = VARIABLES.adminDB.queryBrands() />

        <cfloop query = "LOCAL.brands" >
            <cfset StructInsert(LOCAL.brandlist, #BrandId#, #BrandName#) />
        </cfloop>

        <cfreturn #LOCAL.brandlist#/>
    </cffunction>

    <!--- sends suppliers list  --->
    <cffunction name = "getSuppliers" access = "remote" returnType = "any" returnFormat = "json">
        <cfset supplierlist = {}/>

        <cfset LOCAL.response = VARIABLES.adminDB.querySuppliers() />

        <cfloop query = "LOCAL.response.result" >
            <cfset StructInsert(supplierlist, #SupplierId#, #CompanyName#) />
        </cfloop>

        <cfreturn #supplierlist#/>
    </cffunction>

    <!--- gets products list for subcategory id --->
    <cffunction name = "getProducts" access = "remote" returntype = "Any" returnformat = "json"  >
        <cfargument name = "scatid" type = "numeric" required = "true"  />
        <cfset LOCAL.productsObj = []/>


            <cfset LOCAL.products = VARIABLES.adminDB.queryProductsForSubCategory( argumentcollection = "#ARGUMENTS#" ) />

            <cfloop query = "LOCAL.products" >
                <cfset ArrayAppend(productsObj, {
                        "ProductId" = "#ProductId#",
                        "BrandId" = "#BrandId#",
                        "Description" = "#Description#" ,
                        "ListPrice" = "#ListPrice#" ,
                        "Name" = "#Name#" ,
                        "Qty" = "#Qty#" ,
                        "SupplierId" = "#SupplierId#",
                        "SubCategoryId" = "#SubCategoryId#"
                    })/>
            </cfloop>

        <cfreturn #productsObj# />
    </cffunction>


    <!--- get subcategories name in json object format  --->
    <cffunction name = "getSubCategoriesJSON" returntype = "Array" returnformat = "JSON" output = "false" access = "remote">
        <cfargument name = "categoryid" type = "numeric" required = "true"  />
        <cfset LOCAL.result = []/>

        <cfset LOCAL.subCategoriesQuery = super.getSubCategories( CategoryId = #ARGUMENTS.categoryid# ) />

        <cfloop query = "LOCAL.subCategoriesQuery" >
            <cfset ArrayAppend( LOCAL.result, #SubCategoryName# ) />
        </cfloop>
        <cfreturn #LOCAL.result# />
    </cffunction>


    <!--- adds a subcategory by the admin --->
    <cffunction name = "addSubCategory" access = "remote" returntype = "any" returnformat = "JSON" output = "true" >
        <cfargument name = "categoryid" type = "numeric" required = "true" />
        <cfargument name = "subcategoryname" type = "string" required = "true" />

        <cftry>
            <cfset exists = searchDuplicates(subcategoryname = arguments.subcategoryname, query = "subcategoryname")/>

            <cfif NOT #exists#>
                <cfset VARIABLES.adminDB.insertSubCategory( argumentcollection = "#ARGUMENTS#" ) />
                <cfreturn true>
            <cfelse>
                <cfreturn false/>
            </cfif>

            <cfcatch>
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- for adding a brand --->
    <cffunction name = "addBrand" access = "remote" returntype = "any" returnformat = "JSON" output = "true">
        <cfargument name = "brand" required = "true" type = "string"/>
        <cftry>
            <cfset exists = searchDuplicates(brand = arguments.brand, query = "brandname")/>
            <cfif not #exists#>

                <cfset VARIABLES.adminDB.insertBrand( brand = #ARGUMENTS.brand# ) />

                <cfreturn true/>
            <cfelse>
                <cfreturn false/>
            </cfif>
        <cfcatch>
            <cfdump var = "#cfcatch#" />
            <cfreturn "error"/>
        </cfcatch>
        </cftry>
    </cffunction>

    <!--- for adding a category  --->
    <cffunction name = "addCategory" output = "true" returntype = "Any" returnformat = "JSON" access = "remote" >
        <cfargument name = "categoryname" required = "true" type = "string" />

        <cftry>
            <cfset exists = searchDuplicates(categoryname = arguments.categoryname, query = "categoryname")/>
            <cfif not #exists#>

                <cfset VARIABLES.adminDB.insertCategory( categoryname = #ARGUMENTS.categoryname# ) />
                <cfreturn true>
            <cfelse>
                <cfreturn false/>
            </cfif>

            <cfcatch>
                <cfdump var = "#cfcatch#" />
                <cfreturn "error"/>
            </cfcatch>
        </cftry>
    </cffunction>

    <!--- for searching duplicate brands , categories Or Subcategorie.  switch case used. --->
    <cffunction name = "searchDuplicates" output = "true" returntype = "boolean" access = "remote">
        <cfargument name = "query" required = "true" type = "string"/>
        <cftry>

            <cfswitch expression = "#ARGUMENTS.query#" >


                <cfcase value = "categoryname" >
                    <cfset LOCAL.categoryQuery = VARIABLES.adminDB.queryForCategory( argumentcollection = "#ARGUMENTS#" ) />

                    <cfif LOCAL.categoryQuery.recordCount>
                        <cfreturn true/>
                        <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>


                <cfcase value = "subcategoryname" >
                    <cfset LOCAL.subCategoryQuery = VARIABLES.adminDB.queryForSubCategory( argumentcollection = "#ARGUMENTS#" ) />

                    <cfif LOCAL.subCategoryQuery.recordCount>
                        <cfreturn true/>
                        <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>


                <cfcase value = "brandname" >
                    <cfset LOCAL.brandQuery = VARIABLES.adminDB.queryForBrand( argumentcollection = "#ARGUMENTS#" ) />

                    <cfif LOCAL.brandQuery.recordCount>
                        <cfreturn true/>
                    <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>
            </cfswitch>


            <cfcatch>
                <cfdump var = "#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>



    <!--- for adding a product form admin page.  --->
    <cffunction name = "addProduct" output = "true" access = "remote" returntype = "boolean" >
        <cfdump var = "#arguments#" />
        <!--- <cfquery name = "insertProduct">
            INSERT INTO [Product]
            (Name, BrandId, SubCategoryId, SupplierId, ListPrice, Qty, Description, Image)
            VALUES
            (
                <cfqueryparam value = "#form.Name#" cfsqltype = "cf_sql_char" >,
                <cfqueryparam value = "#form.BrandId#" cfsqltype = "cf_sql_int" >,
                <cfqueryparam value = "#form.SubCategoryId#" CFSQLType = "cf_sql_int" >,
                <cfqueryparam value = "#form.SupplierId#" cfsqltype = "cf_sql_int" >,
                <cfqueryparam value = "#form.ListPrice#" cfsqltype = "cf_sql_bigint" >,
                <cfqueryparam value = "#form.Qty#" cfsqltype = "cf_sql_int" >,
                <cfqueryparam value = "#form.Description#" cfsqltype = "CF_SQL_NVARCHAR" >,
                <cfqueryparam value = "#image#" cfsqltype = "cf_sql_nvarchar">
            )
        </cfquery> --->
    </cffunction>

    <!--- for adding a new product dummy returning the same data for some purpose. I don 't remember --->
    <cffunction name = "addNewProduct" access = "remote" returnType = "any" returnFormat = "json">
        <cfargument name = "formdata" type = "any" required = "true" />
        <cftry>

            <cfreturn #ARGUMENTS.formdata#/>
            <cfcatch >
                <cfdump var = "#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>

</cfcomponent>
