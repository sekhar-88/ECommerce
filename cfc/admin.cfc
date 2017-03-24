<cfcomponent>
    <cffunction name="getBrands" access="remote" returnType="any" returnFormat="json" >
        <cfquery name="brands">
            SELECT BrandId, BrandName
            FROM [Brand]
        </cfquery>

        <cfset brandlist = {}/>
        <cfloop query="brands" >
            <cfset StructInsert(brandlist, #BrandId#, #BrandName#) />
        </cfloop>
        <cfreturn #brandlist#/>
    </cffunction>

    <cffunction name="getSuppliers" access="remote" returnType="any" returnFormat="json">
        <cfquery name="suppliers">
            SELECT *
            FROM [Supplier]
        </cfquery>

        <cfset supplierlist = {}/>
        <cfloop query="suppliers" >
            <cfset StructInsert(supplierlist, #SupplierId#, #CompanyName#) />
        </cfloop>
        <cfreturn #supplierlist#/>
    </cffunction>

    <cffunction name="addNewProduct" access="remote" returnType="any" returnFormat="json">
        <cfargument name="formdata" type="any" required="true" />
        <cftry>

            <cfreturn #arguments.formdata#/>
            <cfcatch >
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getProducts" access="remote" returntype="Any" returnformat="json"  >
        <cfargument name="scatid" type="numeric" required="true"  />
        <cftry>
            <cfquery name="products">
                SELECT * from [Product]
                WHERE SubCategoryId = <cfqueryparam value="#arguments.scatid#" cfsqltype="cf_sql_smallint">
            </cfquery>

            <cfset productsObj = []/>

            <cfloop query="products" >
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
            <cfcatch >
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>

    </cffunction>

</cfcomponent>
