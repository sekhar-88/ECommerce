<cfcomponent>

    <cfset VARIABLES.productDB = CreateObject("db.product_db")/>


<!--- This function updates the product details from editing the product in product details page --->
    <cffunction name = "updateProductDetails" returntype = "Any" access = "remote" >
        <cfargument name="productUpdate" type="struct" required = "true"  />
        <cfargument name="imagename" type="string" required = "true" />

        <cfset LOCAL.success = VARIABLES.productDB.updateProductDetails(argumentcollection = "#ARGUMENTS#") />
        <cfreturn LOCAL.success />
    </cffunction>


    <cffunction name = "user_checkout" returntype = "boolean" returnformat = "json" output = "true" access = "remote">
        <cfargument name = "pid" type = "numeric" required = "true" />
          <cfset addedToCart = addToCart(arguments.pid)/>
          <cfreturn #addedToCart# />
    </cffunction>


<!--- HINT : this method is called while adding to cart by clicking "addtocart" or directy clicking on "buynow" button --->
    <cffunction name = "addToCart" returnType = "boolean" returnFormat = "json" access = "remote" output = "false">
        <cfargument name = "pid" type = "numeric" required = "true" />

            <cfif session.loggedin>
                <cfset userid = #session.User.UserId# />

                <!--- QUERY FOR ALREADY EXISTING PRODUCT --->
                <cfset LOCAL.cart = VARIABLES.productDB.queryCartForProduct( pid = #ARGUMENTS.pid# ) />

                <cfif LOCAL.cart.recordCount >    <!--- in cart --->
                    <cfreturn true/>                <!--- THIS RETURN TRUE IS FOR sending (buynow) button that it is already in cart --->

                <cfelse>           <!--- not in cart --->
                    <cfset LOCAL.price = getPriceOfProduct(arguments.pid)/>
                    <cfset VARIABLES.productDB.insertIntoCart( pid = #ARGUMENTS.pid#, price = "#LOCAL.price#" ) />

                    <!--- cart data changed --->
                    <cfset SESSION.cartDataChanged = true/>;
                    <cfreturn true />
                </cfif>

            <cfelse>  <!---not logged in  ADD TO Session Cart--->
                <cfif ArrayContains(session.cart, #arguments.pid#)>
                    <cfreturn false/>
                <cfelse>
                    <cfset ArrayAppend(session.cart, #arguments.pid#) /> <!--- Store in Session --->
                    <cfset session.cartDataChanged = true/>
                    <cfreturn true />
                </cfif>
            </cfif>
    </cffunction>



    <cffunction name = "getProductsForSubCat" access = "remote" returntype = "Query" output = "false" >
        <cfargument name = "scat" required = "true" type = "numeric" output = "false" />

        <cfset LOCAL.products = VARIABLES.productDB.queryProductsForSubCategory( argumentcollection = "#ARGUMENTS#" ) />

        <cfreturn #LOCAL.products#/>
    </cffunction>

    <cffunction name="getFilteredProducts" access = "remote" returntype = "Struct" returnformat = "JSON" >
        <cfargument name="scat" required = "true" type = "numeric" />
        <cfargument name="brandid" required = "false" type="numeric" default = -1 />
        <cfargument name="pricemin" required = "false" type = "numeric" default = -1 />
        <cfargument name="pricemax" required = "false" type = "numeric" default = -1 />

        <cfset LOCAL.response = VARIABLES.productDB.queryProductsWithFilters( argumentcollection = "#ARGUMENTS#" ) />

        <cfreturn LOCAL.response />
    </cffunction>


    <cffunction name = "getPriceOfProduct" access = "remote" returntype = "boolean" output = "true">
        <cfargument name = "pid" required = "true" type = "numeric"/>
        <cfset LOCAL.ListPrice = 0 />

        <cfset LOCAL.product = VARIABLES.productDB.getProduct( argumentcollection = "#ARGUMENTS#" ) />

        <cfreturn LOCAL.product.ListPrice />
    </cffunction>


<!--- fetch product detials to Show in product Details page --->
    <cffunction name = "fetchProductDetails" access = "remote" returntype = "query" output = "true">
        <cfargument name = "pid" required = "true" type = "numeric" />

        <cfset LOCAL.productDetails = VARIABLES.productDB.queryProductDetailsAndBrand(pid = #ARGUMENTS.pid#) />

        <cfreturn LOCAL.productDetails />
    </cffunction>


    <cffunction name = "isProductInCart" returntype = "boolean" access = "public" >
        <cfargument name = "pid" type = "numeric" required = "true" />

        <cfset LOCAL.inCart = false/>

        <!--- get cart count for that product --->
        <cfif SESSION.loggedin >
            <cfset LOCAL.cart = VARIABLES.productDB.queryCartForProduct( pid = #ARGUMENTS.pid# ) />

                <cfif LOCAL.cart.recordCount>
                    <cfset LOCAL.inCart = true/>
                </cfif>
        <cfelse>
                <cfif ArrayContains(session.cart , #pid#)>
                    <cfset LOCAL.inCart = true />
                </cfif>
        </cfif>

        <cfreturn #LOCAL.inCart#/>
    </cffunction>


    <cffunction name = "getavailableProductQuantity" returntype = "numeric" access = "public"  >
        <cfargument name = "pid" type = "numeric" required = "true" />

        <cfset LOCAL.product = VARIABLES.productDB.getProduct( argumentcollection = "#ARGUMENTS#" ) />

        <cfreturn #LOCAL.product.Qty# />
    </cffunction>


    <cffunction name = "filterSubCategories" returntype = "Query" access = "remote"   >
        <cfargument name = "q" type = "string" required = "true"  />

        <cfset LOCAL.q = #Trim(ARGUMENTS.q)# />
        <cfset REReplace(LOCAL.q, "[^\w ]", "", "ALL") />

        <cfset LOCAL.subcategoryFilters = VARIABLES.productDB.getSubCategoryFilters( q = #LOCAL.q# ) />
        <cfreturn LOCAL.subCategoryFilters />
    </cffunction>


    <cffunction name = "filterBrands" returntype = "Query" access = "remote"  >
        <cfargument name = "scat" type = "numeric" required = "true" />
        <cftry>

            <cfset LOCAL.brandsFilter = VARIABLES.productDB.getBrandsFilter( scat = "#ARGUMENTS.scat#" ) />
        <cfcatch>
            <cfoutput>
                soryy an error type  = "#cfcatch.type#" occured
            </cfoutput>
        </cfcatch>
        </cftry>

        <cfreturn LOCAL.brandsFilter />
    </cffunction>

    <cffunction name = "hasProducts" returntype = "Query" access = "remote" >
        <cfargument name = "q" type = "string" required = "true" />
        <cfset LOCAL.q = #Trim(ARGUMENTS.q)# />

        <cfset LOCAL.products = VARIABLES.productDB.queryProducts( q = #LOCAL.q# ) />
        <cfreturn LOCAL.products />

    </cffunction>


<!---
    ADDS A NEW PRODUCT
    BEFORE ADDING SEARCHES FOR EXISTING PRODUCT
 --->
    <cffunction name = "addNewProduct" returntype = "boolean" access = "remote"  >
        <cfargument name = "form" type = "struct" required = "true" />
        <cfargument name = "imageName" type = "string" required = "true"  />

            <cfset LOCAL.success = VARIABLES.productDB.addNewProductToDB(argumentcollection = "#ARGUMENTS#") />

        <cfreturn LOCAL.success />
    </cffunction>


<!--- simple function to fetch SubCategory name from the Subcategory ID --->
    <cffunction name="getSubCategoryName" returntype = "String" access="remote" >
        <cfargument name="scat" type="numeric" required = "true" />

        <cfset LOCAL.subCategory = VARIABLES.productDB.getSubCategoryName( argumentcollection="#ARGUMENTS#" ) />

        <cfreturn LOCAL.subCategory.SubCategoryName />
    </cffunction>

<!---
    this function returns category details like
    categoryname , subcategoryname, categoryid, subcateogry id,
    for a given product id
 --->
    <cffunction name="getSCategoryDetailsForProductId" returntype = "Query" >
        <cfargument name="pid" type="numeric" required = "true" />

        <cfset LOCAL.categoryDetails = VARIABLES.productDB.getSCategoryDetailsForProductId(ARGUMENTS.pid) />

        <cfreturn LOCAL.categoryDetails/>
    </cffunction>


<!---   CHECKS FOR PRODUCTS EXISTS OR NOT
        BEFORE ADDING TO THE PRODUCT DATABASE
--->
    <cffunction name="checkExistingProduct" returnformat = "json" returntype="boolean" access = "remote" >
        <cfargument name="name" type = "string" required = "true" />

        <cftry >
            <cfset LOCAL.productExists = VARIABLES.productDB.queryExistingProductByName(name = #ARGUMENTS.name#) />

            <cfcatch >
                <cfdump var="#cfcatch#" />
            </cfcatch>
        </cftry>

        <cfreturn LOCAL.productExists />
    </cffunction>


<!--- tries to delete a product based on its pid --->
    <cffunction name="deleteProduct" returntype = "boolean" returnformat = "json" access = "remote"  output= "true">
        <cfargument name="pid" type="numeric" required = "true" />

        <cfset LOCAL.deleted = VARIABLES.productDB.deleteProductFromDB( pid = #ARGUMENTS.pid# )/>

        <cfreturn LOCAL.deleted />
    </cffunction>

    <!--- If delete Not successful, then marks it as discontinued  --->
    <cffunction name="markAsDiscontinued" returntype="boolean" returnformat="json" access="remote" >
        <cfargument name="pid" type="numeric" required = "true" />

        <cfset LOCAL.success = VARIABLES.productDB.markAsDiscontinuedInDB(pid = #ARGUMENTS.pid#) />

        <cfreturn LOCAL.success />
    </cffunction>


</cfcomponent>
