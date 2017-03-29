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

    <cffunction name="addSubCategory" access="remote" returntype="any" returnformat="JSON" output="true" >
        <cfargument name="categoryid" type="numeric" required="true" />
        <cfargument name="subcategoryname" type="string" required="true" />

        <cftry>
            <cfquery name="insertNewSubcategory">
                INSERT INTO [ProductSubCategory]
                (SubCategoryName, CategoryId)
                VALUES
                (
                    <cfqueryparam value="#arguments.subcategoryname#" cfsqltype="cf_sql_nvarchar" />,
                    <cfqueryparam value="#arguments.categoryid#" cfsqltype="cf_sql_int" />
                )
            </cfquery>
            <cfreturn true>

            <cfcatch>
                <cfdump var="#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="getSubCategoriesJSON" returntype="Array" returnformat="JSON" output="false" access="remote">
        <cfargument name="categoryid" type="numeric" required="true"  />
        <cfset result = []/>
        <cfquery name="subcategories">
            Select SubCategoryId, SubCategoryName
            from [ProductSubCategory]
            WHERE CategoryId = #arguments.categoryid#
        </cfquery>

        <cfloop query="subcategories" >
            <cfset ArrayAppend(result, #SubCategoryName#)/>
        </cfloop>
        <cfreturn #result# />
    </cffunction>
</cfcomponent>
