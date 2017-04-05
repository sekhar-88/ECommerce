<cfcomponent>
    <cfset VARIABLES.productDB = CreateObject("db.product_db")/>


    <cffunction name="user_checkout" returntype="boolean" returnformat="json" output="true" access="remote">
        <cfargument name="pid" type="numeric" required="true" />
          <cfset addedToCart = addToCart(arguments.pid)/>
          <cfreturn #addedToCart# />
    </cffunction>


<!--- HINT : this method is called while adding to cart by clicking "addtocart" or directy clicking on "buynow" button --->
    <cffunction name = "addToCart" returnType = "boolean" returnFormat="json" access = "remote" output="false">
        <cfargument name="pid" type="numeric" required="true" />

            <cfif session.loggedin>
                <cfset userid = #session.User.UserId# />

                <!--- QUERY FOR ALREADY EXISTING PRODUCT --->
                <cfinvoke method="queryCartForProduct" component="#VARIABLES.productDB#"
                    returnvariable="REQUEST.cart" pid = #ARGUMENTS.pid# />

                <cfif REQUEST.cart.recordCount >    <!--- in cart --->
                    <cfreturn true/>                <!--- THIS RETURN TRUE IS FOR sending (buynow) button that it is already in cart --->

                <cfelse>           <!--- not in cart --->
                    <cfset LOCAL.price = getPriceOfProduct(arguments.pid)/>
                    <cfinvoke method="insertIntoCart" component="#VARIABLES.productDB#"
                        returnvariable = "cart" pid = #ARGUMENTS.pid# price="#LOCAL.price#" />

                    <!--- cart data changed --->
                    <cfset session.cartDataChanged = true/>;
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

        <cfinvoke method = "queryProductsForSubCategory" component = "#VARIABLES.productDB#"
            returnvariable = "LOCAL.products" argumentcollection = "#ARGUMENTS#"  />

        <cfreturn #LOCAL.products#/>
    </cffunction>



    <cffunction name = "getPriceOfProduct" access = "remote" returntype = "boolean" output = "true">
        <cfargument name = "pid" required = "true" type = "numeric"/>
        <cfset LOCAL.ListPrice = 0 />

        <cfinvoke method="getProduct" component = "#VARIABLES.productDB#"
            returnvariable="LOCAL.product" argumentcollection="#ARGUMENTS#" />

        <cfreturn #LOCAL.product.ListPrice#/>
    </cffunction>



    <cffunction name = "fetchProductDetails" access = "remote" returntype="query" output="true">
        <cfargument name="pid" required="true" type="numeric" />

        <cfinvoke method="queryProductDetailsAndBrand" component="#VARIABLES.productDB#"
            returnvariable="LOCAL.productDetails" pid = "#ARGUMENTS.pid#" />

        <cfreturn #LOCAL.productDetails#/>
    </cffunction>


    <cffunction name="isProductInCart" returntype="boolean" access = "public" >
        <cfargument name = "pid" type = "numeric" required = "true" />

        <cfset LOCAL.inCart = false/>

        <!--- get cart count for that product --->
        <cfinvoke method="queryCartForProduct" component="#VARIABLES.productDB#"
            returnvariable="REQUEST.cart" pid = #ARGUMENTS.pid# />

            <cfif REQUEST.cart.recordCount>
                <cfset LOCAL.inCart = true/>
            </cfif>

        <cfreturn #LOCAL.inCart#/>
    </cffunction>

    <cffunction name="getavailableProductQuantity" returntype = "numeric" access="public"  >
        <cfargument name="pid" type="numeric" required="true" />

        <cfinvoke method="getProduct" component="#VARIABLES.productDB#"
            returnvariable="REQUEST.product" argumentcollection="#ARGUMENTS#"  />

        <cfreturn #REQUEST.product.Qty# />
    </cffunction>
</cfcomponent>
