<!---
    Controller info : product.cfc
    this component contains all the product related fuctions & objects which are used mostly on
    product.cfm or productDetails.cfm page of the ecommerce application
--->

<cfcomponent displayname="prodct.cfc" hint="this_component contains all Product related functions" >

    <!--- creating ontime object of its underlying Database logic --->
    <cfset VARIABLES.productDB = CreateObject("db.product_db") />


    <!---
        this function checks if the provided category or subcategory id in the URL is valid or not.
        returns true or false accordingly, if any error found the result is always false
        return type boolean
    --->
    <cffunction name="categorySubcategoryExists" returntype="boolean" access = "remote" output = "true" >
        <cfargument name="cat" required = "true"  type = "numeric" />
        <cfargument name="scat" required = "true" type = "numeric" />

        <cftry>
            <cfset LOCAL.categorySubcategoryValid = VARIABLES.productDB.categorySubcategoryExists( argumentcollection = #ARGUMENTS# ) />

            <cfif IsBoolean(LOCAL.categorySubcategoryValid)>
                <cfset LOCAL.response = LOCAL.categorySubcategoryValid />
            <cfelse>
                <cfset LOCAL.response = false />
            </cfif>

            <cfcatch type = "any">
                <cfset LOCAL.response = false />
            </cfcatch>
        </cftry>

        <cfreturn LOCAL.response />
    </cffunction>

    <!--- This function updates the product details from editing the product in product details page --->
    <cffunction name = "updateProductDetails" returntype = "Any" access = "remote" >
        <cfargument name="productUpdate" type="struct" required = "true"  />
        <cfargument name="imagename" type="string" required = "true" />

        <cfset LOCAL.success = VARIABLES.productDB.updateProductDetails( argumentcollection = "#ARGUMENTS#" ) />

        <cfreturn LOCAL.success />
    </cffunction>

    <!---
        Function     : user_checkout
        Hint         : adds the product to cart if user directly clicked on buy now button instead of clicking the add to cart button
        Return Type  : boolean
        return format: JSON
     --->
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
                    <cfset SESSION.cartDataChanged = true />
                    <cfset SESSION.User.paymentDataChanged = true />
                    <cfreturn true />
                </cfif>

            <cfelse>  <!---not logged in  ADD TO Session Cart--->
                <cfif ArrayContains(session.cart, #arguments.pid#)>
                    <cfreturn false/>
                <cfelse>
                    <cfset ArrayAppend(session.cart, #arguments.pid#) /> <!--- Store in Session --->
                    <cfset session.cartDataChanged = true/>
                    <cfset SESSION.User.paymentDataChanged = true />
                    <cfreturn true />
                </cfif>
            </cfif>
    </cffunction>


    <!---
        Function     :
        Hint         :
        Return Type  :
        return format:
     --->
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

    <!---
        Function     : filterBrands
        Hint         : filter & show the brands depending on the product that based on products subcateogry.
        Return Type  : Query
        return format: N/A
     --->
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

    <!---
        Function     : hasProducts
        Hint         : if the cart has products or not.
        Return Type  : query
        return format: N/A
     --->
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


    <!---
        function: checkExistingProduct
        Hint    : CHECKS FOR PRODUCTS EXISTS OR NOT
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


    <!---
        function: deleteProduct
        hint    : tries to delete a product based on its pid
    --->
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



<!--- format: --->
<!---
    Function     :
    Hint         :
    Return Type  :
    return format:
 --->
