<cfcomponent extends = "header" >
    <cfset VARIABLES.adminDB = CreateObject("db.admin_db") />

    <cffunction name = "getBrands" access = "remote" returnType = "any" returnFormat = "json" >
        <cfset LOCAL.brandlist = {}/>

        <cfinvoke method = "queryBrands" component = "#VARIABLES.adminDB#"
            returnvariable = "LOCAL.brands" />

        <cfloop query = "LOCAL.brands" >
            <cfset StructInsert(LOCAL.brandlist, #BrandId#, #BrandName#) />
        </cfloop>

        <cfreturn #LOCAL.brandlist#/>
    </cffunction>


    <cffunction name = "getSuppliers" access = "remote" returnType = "any" returnFormat = "json">
        <cfset supplierlist = {}/>

        <cfinvoke method = "querySuppliers" component = "#VARIABLES.adminDB#"
            returnvariable = "LOCAL.suppliers" />

        <cfloop query = "LOCAL.suppliers" >
            <cfset StructInsert(supplierlist, #SupplierId#, #CompanyName#) />
        </cfloop>

        <cfreturn #supplierlist#/>
    </cffunction>


    <cffunction name = "getProducts" access = "remote" returntype = "Any" returnformat = "json"  >
        <cfargument name = "scatid" type = "numeric" required = "true"  />
        <cfset LOCAL.productsObj = []/>

            <cfinvoke method = "queryProductsForSubCategory" component = "#VARIABLES.adminDB#"
                returnvariable = "LOCAL.products" argumentcollection = "#ARGUMENTS#"  />

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


    <cffunction name = "getSubCategoriesJSON" returntype = "Array" returnformat = "JSON" output = "false" access = "remote">
        <cfargument name = "categoryid" type = "numeric" required = "true"  />
        <cfset LOCAL.result = []/>

        <cfset LOCAL.subCategoriesQuery = super.getSubCategories( CategoryId = #ARGUMENTS.categoryid# ) />

        <cfloop query = "LOCAL.subCategoriesQuery" >
            <cfset ArrayAppend( LOCAL.result, #SubCategoryName# ) />
        </cfloop>
        <cfreturn #LOCAL.result# />
    </cffunction>


    <cffunction name = "addSubCategory" access = "remote" returntype = "any" returnformat = "JSON" output = "true" >
        <cfargument name = "categoryid" type = "numeric" required = "true" />
        <cfargument name = "subcategoryname" type = "string" required = "true" />

        <cftry>
            <cfset exists = searchDuplicates(subcategoryname = arguments.subcategoryname, query = "subcategoryname")/>

            <cfif not #exists#>

                <cfinvoke method = "insertSubCategory" component = "#VARIABLES.adminDB#"
                    argumentcollection = "#ARGUMENTS#" />
                <cfreturn true>
            <cfelse>
                <cfreturn false/>
            </cfif>

            <cfcatch>
                <cfdump var = "#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>


    <cffunction name = "addBrand" access = "remote" returntype = "any" returnformat = "JSON" output = "true">
        <cfargument name = "brand" required = "true" type = "string"/>
        <cftry>
            <cfset exists = searchDuplicates(brand = arguments.brand, query = "brandname")/>
            <cfif not #exists#>

                <cfinvoke method = "insertBrand" component = "#VARIABLES.adminDB#"
                    brand = #ARGUMENTS.brand# />

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


    <cffunction name = "addCategory" output = "true" returntype = "Any" returnformat = "JSON" access = "remote" >
        <cfargument name = "categoryname" required = "true" type = "string" />

        <cftry>
            <cfset exists = searchDuplicates(categoryname = arguments.categoryname, query = "categoryname")/>
            <cfif not #exists#>

                <cfinvoke method = "insertCategory" component = "#VARIABLES.adminDB#"
                    categoryname = #ARGUMENTS.categoryname# />

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


    <cffunction name = "searchDuplicates" output = "true" returntype = "boolean" access = "remote">
        <cfargument name = "query" required = "true" type = "string"/>
        <cftry>

            <cfswitch expression = "#ARGUMENTS.query#" >


                <cfcase value = "categoryname" >
                    <cfinvoke method = "queryForCategory" component = "#VARIABLES.adminDB#"
                        returnvariable = "LOCAL.categoryQuery" argumentcollection = "#ARGUMENTS#"  />

                    <cfif LOCAL.categoryQuery.recordCount>
                        <cfreturn true/>
                        <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>


                <cfcase value = "subcategoryname" >
                    <cfinvoke method = "queryForSubCategory" component = "#VARIABLES.adminDB#"
                        returnvariable = "LOCAL.subCategoryQuery" argumentcollection = "#ARGUMENTS#" />

                    <cfif LOCAL.subCategoryQuery.recordCount>
                        <cfreturn true/>
                        <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>


                <cfcase value = "brandname" >
                    <cfinvoke method = "queryForBrand" component = "#VARIABLES.adminDB#"
                        returnvariable = "LOCAL.brandQuery" argumentcollection = "#ARGUMENTS#" />

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
