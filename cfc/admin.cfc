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




    <cffunction name="addSubCategory" access="remote" returntype="any" returnformat="JSON" output="true" >
        <cfargument name="categoryid" type="numeric" required="true" />
        <cfargument name="subcategoryname" type="string" required="true" />

        <cftry>
            <cfset exists = searchDuplicates(subcategoryname = arguments.subcategoryname, query = "subcategoryname")/>
            <cfif not #exists#>
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
            <cfelse>
                <cfreturn false/>
            </cfif>

            <cfcatch>
                <cfdump var="#cfcatch#" />
                <cfreturn false/>
            </cfcatch>
        </cftry>
    </cffunction>


    <cffunction name="addBrand" access="remote" returntype="any" returnformat="JSON" output="true">
        <cfargument name="brand" required="true" type="string"/>
        <cftry>
            <cfset exists = searchDuplicates(brand = arguments.brand, query="brandname")/>
            <cfif not #exists#>
                <cfquery name="insertBrand">
                    INSERT INTO [Brand]
                    (BrandName)
                    VALUES
                    (<cfqueryparam value="#arguments.brand#" cfsqltype="cf_sql_nvarchar" />)
                </cfquery>
                <cfreturn true/>
            <cfelse>
                <cfreturn false/>
            </cfif>
        <cfcatch>
            <cfdump var="#cfcatch#" />
            <cfreturn "error"/>
        </cfcatch>
        </cftry>

    </cffunction>


    <cffunction name="addCategory" output="true" returntype="Any" returnformat="JSON" access="remote" >
        <cfargument name="categoryname" required="true" type="string" />
        <cftry >

        <cfset exists = searchDuplicates(categoryname = arguments.categoryname, query="categoryname")/>
        <cfif not #exists#>
            <cfquery name="insertCategory">
                INSERT INTO [ProductCategory]
                (CategoryName)
                VALUES
                (<cfqueryparam value="#arguments.categoryname#" cfsqltype="cf_sql_nvarchar" />)
            </cfquery>
            <cfreturn true>
        <cfelse>
            <cfreturn false/>
        </cfif>
        <cfcatch>
            <cfdump var="#cfcatch#" />
            <cfreturn "error"/>
        </cfcatch>
        </cftry>

    </cffunction>


    <cffunction name="searchDuplicates" output="true" returntype="boolean" access="remote">
        <cfargument name="query" required="true" type="string"/>
        <cftry>

            <cfswitch expression="#arguments.query#" >

                <cfcase value="categoryname" >

                    <cfquery name="searchResult">
                        SELECT * FROM [ProductCategory] WHERE CategoryName = <cfqueryparam value="#arguments.categoryname#" cfsqltype="cf_sql_nvarchar" />
                    </cfquery>
                    <cfif searchResult.recordCount>
                        <cfreturn true/>
                        <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>




                <cfcase value="subcategoryname" >

                    <cfquery name="searchResult">
                        SELECT * FROM [ProductSubCategory] WHERE SubCategoryName = <cfqueryparam value="#arguments.subcategoryname#" cfsqltype="cf_sql_nvarchar" />
                    </cfquery>
                    <cfif searchResult.recordCount>
                        <cfreturn true/>
                        <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>




                <cfcase value="brandname" >

                    <cfquery name="searchBrands">
                        SELECT *
                        FROM [Brand]
                        WHERE BrandName = <cfqueryparam value="#arguments.brand#" cfsqltype="cf_sql_nvarchar" />
                    </cfquery>
                    <cfif searchBrands.recordCount>
                        <cfreturn true/>
                    <cfelse>
                        <cfreturn false/>
                    </cfif>

                </cfcase>
            </cfswitch>


            <cfcatch>
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>
    </cffunction>

    <cffunction name="addProduct" output="true" access="remote" returntype="boolean" >
        <cfdump var="#arguments#" />
        <!--- <cfquery name="insertProduct">
            INSERT INTO [Product]
            (Name, BrandId, SubCategoryId, SupplierId, ListPrice, Qty, Description, Image)
            VALUES
            (
                <cfqueryparam value="#form.Name#" cfsqltype="cf_sql_char" >,
                <cfqueryparam value="#form.BrandId#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#form.SubCategoryId#" CFSQLType = "cf_sql_int" >,
                <cfqueryparam value="#form.SupplierId#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#form.ListPrice#" cfsqltype="cf_sql_bigint" >,
                <cfqueryparam value="#form.Qty#" cfsqltype="cf_sql_int" >,
                <cfqueryparam value="#form.Description#" cfsqltype="CF_SQL_NVARCHAR" >,
                <cfqueryparam value="#image#" cfsqltype="cf_sql_nvarchar">
            )
        </cfquery> --->

    </cffunction>

</cfcomponent>
