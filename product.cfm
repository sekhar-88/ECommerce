<cfset productCFC = CreateObject("cfc.product") />

<!DOCTYPE html>
<head>
    <cfinclude template = "assets/libraries/libraries.cfm">
    <link href="assets/css/product.css" rel="stylesheet">
    <script src="assets/js/product.js"></script>

    <!--- <cfdump var="#session#" /> --->
    <cfif StructKeyExists(session.User, "Role") AND session.User.Role EQ "admin">
        <script src="assets/js/adminpage.js"></script>
    </cfif>
</head>
<!---
.container-fluid
    .filter
    .products
        .product
            .product_image      /
            .product_content    /  .product_info
                .product_pricing    /

--->
    <body>
    <div id="header"><cfinclude template = "commons/header.cfm" /></div>

    <!--- page refresh logic --->
    <input type="hidden" id="refreshed" value="no"/>

    <div class="modal fade" tabindex="-1" role="dialog" id="add-product-modal">
      <div class="modal-dialog" role="document" style="width: 450px;">
        <div class="modal-content" style="-webkit-border-radius: 0px !important;-moz-border-radius: 0px !important;border-radius: 0px !important;">

          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">Modal title</h4>
          </div>

          <div class="modal-body">
              <form class="" action="" enctype="multipart/form-data" method="post" id="product_add_form" name="product_add_form">
                  <div id="form-header">add new product</div>

                  <div class="form-group">
                      <label>Product Name: </label>
                      <input type="text" name="Name" required>
                  </div>

                  <div class="form-group">
                      <label>Brand: </label>
                      <select name="BrandId" id="brands_select_list" required>
                      </select>
                  </div>

                  <div class="form-group">
                      <input  name="SubCategoryId" id="subCategoryValue" type="hidden" value="" required/>
                  </div>

                  <div class="form-group" class="hidden">
                      <label>Supplier(self): </label>
                      <select name="SupplierId" id="suppliers_select_list" required>
                      </select>
                  </div>

                  <div class="form-group">
                      <label>Stock Quantity: </label>
                      <input type="number" min="0" name="Qty" value="1" required/>
                  </div>

                  <div class="form-group">
                      <label>ListPrice(&#8377;): </label>
                      <input type="number" min="0" name="ListPrice" required />
                  </div>

                  <div class="form-group">
                      <label>Description: </label>
                      <textarea name="Description" placeholder="Product Description Goes Here..." cols="22" value="Description"></textarea>
                  </div>

                  <div class="form-group">
                      <label>Images File: </label>
                      <input type="file" id="imageFile" name="Image" accept="image/jpeg" required>
                  </div>

                  <div class="form-group">
                      <button type="submit" name="submit">Add Product</button>
                      <button type="reset" name="reset">Clear</button>
                  </div>
              </form>
          </div>

          <div class="modal-footer">
            <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            <button type="button" class="btn btn-primary">Save changes</button>
          </div>

        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

<!--- Body content --->
    <div class="container-fluid">

                <div class="filters">

                    <div class="filter filter-brand">
                        <div class="filter-header">Brands</div>

                        <cfset VARIABLES.brandFilter = productCFC.filterBrands(URL.scat) />
                        <cfoutput>

                            <form id="brands-filter">
                                <cfloop query="VARIABLES.brandFilter" >
                                    <div class="checkbox" style="padding-left: 10px;padding-top: 2px;">
                                        <label><input type="checkbox" name="brand" value="#BrandId#"> #BrandName#</label>
                                    </div>
                                </cfloop>
                            </form>

                        </cfoutput>
                    </div>

                    <div class="filter filter-price">
                        <div class="filter-header">Price</div>
                    </div>

                    <div class="filter filter-other">
                        <div class="filter-header"></div>
                    </div>

                </div>

                <div class="products">
                <cfif StructKeyExists(URL, "cat") AND StructKeyExists(URL, "scat")>
                            <cfset productCFC = createObject("cfc.product") />
                            <cfset productsQuery = productCFC.getProductsForSubCat(scat = #URL.scat#) />

                            <cfif StructKeyExists(session.User, "Role") AND session.User.Role EQ "admin">
                            <cfoutput>
                            <div class="productadd" data-scat="#URL.scat#" onclick="addNewProduct(this);">

                                <div class="product_image">
                                    <img src="assets/images/products/commons/productaddnew.png" width="300px"/>
                                </div>
                                <div class="product_content" style="display: flex; align-items:center; justify-content:center; ">
                                    <div class="product_name font-size-30 color-grey"> Add New Product In this Category/SubCategory </div>
                                </div>
                            </div>
                            </cfoutput>
                            </cfif>

                            <cfif productsQuery.recordCount>
                                <cfoutput>
                                <cfloop query = "productsQuery">

                                        <div class="product brand_#BrandId# price_#ListPrice#">

                                                <a href="productDetails.cfm?pid=#ProductId#"></a>
                                                <div class="product_image">
                                                    <img class="" src="assets/images/products/medium/#Image#">
                                                </div>
                                                <div class="product_content">

                                                    <div class="product_name"> #Name# </div>
                                                    <div class="product_pricing">
                                                        <div class="product_price"> #ListPrice#  </div>
                                                        <div class="product_discounted_price">#DiscountPercent#</div>
                                                    </div>

                                                    <ul>
                                                    <cfloop index="i" list="#Description#" delimiters="`"  >
                                                        <li>#i#</li>
                                                    </cfloop>
                                                    </ul>

                                                </div>


                                            </div>
                                </cfloop>
                                </cfoutput>
                            <cfelse>
                                <cfoutput>
                                    <div class="no-product">
                                        <div class="product_info">
                                            <h1 class="">Currently No Products in this Category</h1>
                                        </div>
                                    </div>
                                </cfoutput>
                            </cfif>
                <cfelse>
                        <cflocation url="index.cfm" addToken="false">
                </cfif>
                </div>
    </div>


<cfinclude template = "commons/footer.cfm">
</body>
</html>

<cftry>

<cfif IsDefined("form.Image")>
    <!--- <cfset path = "E:\EclipseWorkSpace\ColdFusion\Project\assets\images\products\medium"/> --->
    <cfset path = "F:\WORK\ColdFusion\Shopping\assets\images\products\medium" />
    <cffile action="upload"
            filefield="Image"
            destination="#path#"
            nameconflict="makeunique"
            accept="image/jpeg,image/jpg,image/png"
            result="uploadresult" />
            <!--- <cfdump var="#uploadresult#" /> --->
            <cfset VARIABLES.image = "#uploadresult.SERVERFILE#" />

            <cfset newProduct = productCFC.addNewProduct(form = FORM, imageName = VARIABLES.image ) />

            <cflocation url="#cgi.HTTP_REFERER#" addtoken="false" />


            <!--- <cfset adminCFC = createObject("cfc.admin") />
            <cfset productAdd = adminCFC.addProduct(#FORM#,#image#)/>
            <cfdump var="#productAdd#"> --->

</cfif>
<cfcatch>
    <cfdump var="#cfcatch#" />
</cfcatch>
</cftry>
