<cfset productCFC = createObject("cfc.product")/>

<!DOCTYPE html>
<html>
<head>
    <script src="assets/js/productDetail.js"></script>
    <cfinclude template = "assets/libraries/libraries.cfm">
      <link href="assets/css/productDetail.css" rel="stylesheet">


    <script>
    </script>
</head>
<body>

<div id="header"><cfinclude template = "commons/header.cfm" /></div>
<!--- page refresh logic --->
<input type="hidden" id="refreshed" value="no" />


<!---   [to be designed] / [WORKED UPON]
.product_details_pd_container

    pd_image
        pd_image-thumbnails
        pd_image-preview
    pd_info
        pd_name
        pd_price
        pd_description
        pd_specification

.featured_product_fp_container
    fp_products carousel
        .fp_product
            .fp_image
            .fp_name
            .fp_price
--->

    <div class="container-fluid page">
        <cfif StructKeyExists(URL, "pid") AND IsNumeric(URL.pid) >
        <cfset VARIABLES.productDetails = productCFC.fetchProductDetails(URL.pid)/>

          <cfif productdetails.recordCount> <!--- Product Exists --->
              <cfoutput>

                    <div class="image-view">

                        <div class="image-container-lg">
                            <img src="assets/images/products/medium/#VARIABLES.productDetails.Image#" alt="">
                        </div>

                        <div id="buttons-container">
                              <cfif NOT isNULL(VARIABLES.productDetails.DiscontinuedDate)>

                            <!--- check for if already in cart  --->
                              <cfset VARIABLES.incart = productCFC.isProductInCart(#URL.pid#)/>
                              <cfif VARIABLES.incart>

                                  <div id="gotocart_btn">    <!--- Show Go To Cart button --->
                                      <button type="button" value="##" onclick="window.location.href='cart.cfm';" class="btn btn-lg btn-primary verdana btn-radius-1"><span class="glyphicon glyphicon"></span> Go To Cart</button>
                                  </div>

                              <cfelse>

                                  <div id="addtocart_btn">  <!--- Show Add to cart  button --->
                                      <button type="button" value="#URL.pid#" onclick="addToCart(this);changeto_gotocart();" class="btn btn-lg btn-primary verdana btn-radius-1"><span class="glyphicon glyphicon-shopping-cart"></span> Add to Cart</button>
                                  </div>

                              </cfif>                         <!--- Show Buy Now Button --->

                              <cfif session.loggedin>
                                  <div>
                                      <button type="button" value="#URL.pid#" onclick="checkOut(this,#session.user.userid#);" class="btn btn-lg btn-success verdana btn-radius-1"><span class="glyphicon glyphicon-usd"></span> Buy Now</button>
                                  </div>

                              <cfelse>
                                  <div>
                                      <button type="button" value="#URL.pid#" onclick="showLoginMsg();" class="btn btn-lg btn-success verdana btn-radius-1"><span class="glyphicon glyphicon-usd"></span> Buy Now</button>
                                  </div>
                              </cfif>

                          <cfelse>

                          </cfif>

                        </div>   <!--- end .pdi-buttons --->
                        <div class="well well-sm login-notify" style="display:none;">
                            <h4>Please <a href="##" data-toggle="dropdown" data-target = ".login_toggle">login</a> to continue.</h4>
                        </div>
                    </div>   <!--- end  .image-view --->


<!---
    [ProductId] ,[Name] ,[BrandId] ,[SubCategoryId] ,[Weight] ,[ListPrice] ,[SupplierId] ,[DiscontinuedDate] ,
    [DiscountPercent] ,[DiscountedPrice] ,[Qty] ,[Description] ,[Image]
 --->
                    <div class="product-details">
                    <cfsavecontent variable="productDetailsHTML" >

                        <div class="pd-name">
                            #productDetails.BrandName# - #productDetails.Name# #productDetails.ListPrice#
                        </div>
                        <div class="pd-rating">
                            <span class="badge">4</span>
                        </div>
                        <div class="pd-price">
                            <span></span><span>#productDetails.ListPrice#</span>
                        </div>
                        <div class="product-specification">
                            <div class="ps-header">Specifications: </div>
                            <div class="ps-content">
                                <div class="ps-content-header"></div>
                                    <ul>
                                        <cfloop index="i" list="#productDetails.Description#" delimiters="`"  >
                                            <li>#i#</li>
                                        </cfloop>
                                    </ul>
                            </div>
                        </div>

                        <cfif structKeyExists(Session.User, "Role") AND SESSION.User.Role EQ 'admin'>
                            <button class="btn btn-warning" onclick="showUpdateModal(#VARIABLES.productDetails.ProductId#);" ><span class="glyphicon glyphicon-pencil"></span>Update Details</button>
                            <button class="btn btn-danger" onclick="deleteProduct(#VARIABLES.productDetails.ProductId#)">Delete Product</button>
                        </cfif>

                    </cfsavecontent>
                    #productDetailsHTML#
                    </div>

              </cfoutput>

          <cfelse>  <!--- Product Not found for the provided pID --->
              <h3 class="text text-danger">Error Getting Product Details</h3>
          </cfif>

        <cfelse>
            <h1 align="center">404</h2>
                <h3 align="center">Reasons:</h3>
                <h4 align="center">The requested Resource is not found</h4>
                <h4 align="center">possibly malformed URL</h4>
        </cfif>
    </div>

<cfinclude template = "commons/footer.cfm">
</body>
</html>
