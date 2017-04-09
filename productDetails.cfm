<cfset productCFC = createObject("cfc.product")/>

<!DOCTYPE html>
<html>
<head>
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
        <cfset VARIABLES.productDetails = productCFC.fetchProductDetails(URL.pid) />

          <cfif VARIABLES.productdetails.recordCount> <!--- Product Exists --->
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
                            <div class="buttons-admin" >
                                <button class="btn btn-warning" onclick="showUpdateModal(#VARIABLES.productDetails.ProductId#);" ><span class="glyphicon glyphicon-pencil"></span> Update Details</button>
                                <button class="btn btn-danger" onclick="deleteProduct(#VARIABLES.productDetails.ProductId#)">Delete Product</button>
                            </div>
                        </cfif>

                    </cfsavecontent>
                    #productDetailsHTML#
                    </div>


                    <form class="" action="" enctype="multipart/form-data" method="post" id="product-update-form" name="product-update-form">
                    <div class="modal fade" tabindex="-1" role="dialog" id="update-product-modal">
                      <div class="modal-dialog" role="document" style="width: 450px;">
                        <div class="modal-content" style="-webkit-border-radius: 0px !important;-moz-border-radius: 0px !important;border-radius: 0px !important;">

                          <div class="modal-header">
                            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                            <h3 align="center" class="modal-title">Update Product</h3>
                          </div>

                          <div class="modal-body">
                              <cfoutput>

                                  <div class="form-group">
                                      <label>Product Name: </label>
                                      <input type="text" name="Name" value="#VARIABLES.productdetails.Name#" required>
                                  </div>

                                  <!--- <div class="form-group">
                                      <label>Brand: </label>
                                      <select name="BrandId" id="brands_select_list" required>
                                      </select>
                                  </div> --->

                                  <div class="form-group">
                                      <input name="ProductId" id="ProductIdValue" type="hidden" value="#VARIABLES.productDetails.ProductId#" required />
                                      <input name="SubCategoryId" id="subCategoryValue" type="hidden" value="23" required />
                                  </div>

                                  <!--- <div class="form-group" class="hidden">
                                      <label>Supplier(self): </label>
                                      <select name="SupplierId" id="suppliers_select_list" required>
                                      </select>
                                  </div> --->

                                  <div class="form-group">
                                      <label>Stock Quantity: </label>
                                      <input type="number" min="0" name="Qty" value="#VARIABLES.productDetails.Qty#" required/>
                                  </div>

                                  <div class="form-group">
                                      <label>ListPrice(&##8377;): </label>
                                      <input type="number" min="0" name="ListPrice" value="#VARIABLES.productDetails.ListPrice#" required />
                                  </div>

                                  <div class="form-group product-desc-fields">
                                      <label>Description: </label>
                                      <cfloop index="i" list="#productDetails.Description#" delimiters="`"  >
                                          <input type="text" value = "#i#" class="y form-control"> <br />
                                      </cfloop>
                                   </div>

                                  <button type="button" onclick='$(this).prev().append("<input type="+"text"+" class="+"x"+" placeholder="+"property"+"> <input type="+"text"+" class="+"x"+" placeholder="+"property"+">")'>add new field</button>
                                  <textarea name="Description" id="prdt-desc" placeholder="Product Description Goes Here..." cols="22" value="Description" class="hidden"></textarea>

                                  <div class="form-group">
                                      <label>Images File: </label>
                                      <input type="hidden" name="Image_old" value="#VARIABLES.productDetails.Image#">
                                      <input type="file" id="imageFile" name="Image" accept="image/jpeg" class="form-control">
                                  </div>

                              </cfoutput>
                          </div>

                          <div class="modal-footer">
                            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                            <button type="submit" name="submit_productupdate" form="product-update-form" class="btn btn-primary">Save changes</button>
                            <button type="reset" class="btn btn-default">Clear</button>
                          </div>

                        </div><!-- /.modal-content -->
                      </div><!-- /.modal-dialog -->
                    </div><!-- /.modal -->
                </form>

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





<!--- modal for updating the product details / --->



<script src="assets/js/productDetail.js"></script>
<cfinclude template = "commons/footer.cfm">
</body>
</html>

<cfif StructKeyExists(FORM, "submit_productupdate") >
    <cfdump var="#FORM#" />
    <cftry >

        <cfif #FORM.Image# NEQ ''>
            <!--- <cfset path = "D:\ShoppingSite\assets\images\products\medium" /> --->
            <cfset path = "F:\WORK\ColdFusion\Shopping\assets\images\products\medium" />

            <cffile action="Delete"
                    file= "#path#\#FORM.Image_old#"
                    />

            <cffile action="upload"
                    filefield   ="Image"
                    destination ="#path#"
                    nameconflict="makeunique"
                    accept      ="image/jpeg,image/jpg,image/png"
                    result      ="uploadresult"
                    />

            <!--- <cfdump var="#uploadresult#" /> --->
            <cfset VARIABLES.imagename = "#uploadresult.SERVERFILE#" />

            <cfset updateProduct = productCFC.updateProductDetails(FORM,#imagename#) />
            <cflocation url="#cgi.HTTP_REFERER#" addtoken="false"   />
        <cfelse>
            <cfset updateProduct = productCFC.updateProductDetails(FORM,FORM.Image_old) />
            <cflocation url="#cgi.HTTP_REFERER#" addtoken="false"   />
        </cfif>

        <cfcatch type="any">
            <cfdump var="#cfcatch#" />
            <cfoutput>
                Error type : #cfcatch.type#
            </cfoutput>
        </cfcatch>
    </cftry>
</cfif>
