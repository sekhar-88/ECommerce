<cfset productCFC = CreateObject("cfc.product") />

<cfif IsNumeric(URL.cat) AND IsNumeric(URL.scat)>
    <cfelse>
        <!--- <script>$(document).ready(function(){$(html).empty();});</script> --->
        <cfinclude template="/commons/error404.cfm" />
        <cfabort />
    </cfif>




<!DOCTYPE html>
<head>
    <cfinclude template = "/include/libraries.cfm">
    <link href="../assets/css/product.css" rel="stylesheet">
    <script src="../assets/js/product.js"></script>

    <!--- <cfdump var="#session#" /> --->
    <cfif StructKeyExists(session.User, "Role") AND session.User.Role EQ "admin">
        <script src="../assets/js/adminpage.js"></script>
    </cfif>
</head>
<!---
.container-fluid
    .filter
    .products
        .product
            .product-image      /
            .product-content    /  .product_info
                .product-pricing    /

--->
    <body>
    <div id="header"><cfinclude template = "/commons/header.cfm" /></div>
    <!--- page refresh logic --->
    <input type="hidden" id="refreshed" value="no"/>


    <form class="" action="" enctype="multipart/form-data" method="post" id="product-add-form" name="product-add-form">
    <div class="modal fade" tabindex="-1" role="dialog" id="add-product-modal">
      <div class="modal-dialog" role="document" style="width: 450px;">
        <div class="modal-content" style="-webkit-border-radius: 0px !important;-moz-border-radius: 0px !important;border-radius: 0px !important;">

          <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
            <h4 class="modal-title">Add New Product</h4>
          </div>

          <div class="modal-body">

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
                      <div></div>
                  </div>
                  <div class="form-group product-desc-fields">
                      <div></div>
                      <input type="text" class="" placeholder="property"><input type="text" name="" placeholder="desc">
                      <input type="text" class="" placeholder="property"><input type="text" name="" placeholder="desc">
                      <!--- <input type="text" class="" placeholder="property"> <input type="text" name="" placeholder="desc"> --->
                  </div>

                  <button type="button" class="btn btn-sm btn-default" onclick='$(this).prev().append("<input type="+"text"+" class="+"x"+" placeholder="+"property"+"><input type="+"text"+" placeholder="+"desc"+">")' style="margin-bottom:5px; position: relative; left: 70%;">add new field</button>
                  <textarea name="Description" id="prdt-desc" placeholder="Product Description Goes Here..." cols="22" value="Description" class="hidden"></textarea>


                  <div class="input-group">
                      <label class="input-group-btn">
                          <span class="btn btn-file">
                              Browse&hellip; <input type="file" id="imageFile" name="Image" accept="image/jpeg" style="display: none;" multiple>
                          </span>
                      </label>
                      <input type="text" class="form-control" readonly>
                  </div>
<!---
                      <label class="btn btn-default btn-file">
                          Images File:
                          <input type="file"  class="file" required>
                      </label>
 --->

              </form>
          </div>

          <div class="modal-footer">
              <button type="submit" class="btn btn-primary">Add Product</button>
              <button type="reset"  class="btn btn-default" name="reset">Clear</button>
              <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
          </div>

        </div><!-- /.modal-content -->
      </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

<!--- Body content --->

    <div class="container-fluid">

                <div class="filters">
                    <h3 class="filter-section-header">
                        Filters
                    </h3>

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
                    <cfset subCategoryName = productCFC.getSubCategoryName(URL.scat) />

                                <h3 class="product-section-header">
                                    <cfoutput>
                                        in  #subCategoryName#
                                    </cfoutput>
                                </h3>

                                <cfset productCFC = createObject("cfc.product") />
                                <cfset productsQuery = productCFC.getProductsForSubCat(scat = #URL.scat#) />
                                <!---
                                    productsQuery - contains these attributes
                                        ProductId, Name, BrandId, SubCategoryid, ListPrice, SupplierId,
                                        DiscontinuedDate, DiscountPercent, DiscountedPrice, Qty,
                                        Description, Image
                                --->
                                <cfif StructKeyExists(session.User, "Role") AND session.User.Role EQ "admin">
                                <cfoutput>
                                <div class="productadd" data-scat="#URL.scat#" onclick="addNewProduct(this);">

                                    <div class="product-image">
                                        <img src="../assets/images/products/commons/productaddnew.png" width="300px"/>
                                    </div>
                                    <div class="product-content" style="display: flex; align-items:center; justify-content:center; ">
                                        <div class="product-name font-size-30 color-grey"> Add New Product In this Category/SubCategory </div>
                                    </div>
                                </div>
                                </cfoutput>
                                </cfif>

                                <cfif productsQuery.recordCount>
                                    <cfoutput>
                                    <cfloop query = "productsQuery">

                                            <div class="product brand_#BrandId# price_#ListPrice#">

                                                    <a href="productDetails.cfm?pid=#ProductId#"></a>
                                                    <div class="product-image">
                                                        <img class="" src="../assets/images/products/medium/#Image#">
                                                    </div>

                                                    <div class="product-content">

                                                        <div class="product-name"> #Name# </div>
                                                        <div class="product-pricing">
                                                            <div class="product-price"> #ListPrice#  </div>
                                                            <div class="product-discounted-price">#DiscountPercent#</div>
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


<cfinclude template = "/commons/footer.cfm">
</body>
</html>

<cftry>

<cfif IsDefined("FORM.Image") AND IsDefined("FORM.submit")>
    <cfset path = "D:\ShoppingSite\assets\images\products\medium" />
    <!--- <cfset path = "F:\WORK\ColdFusion\Shopping\assets\images\products\medium" /> --->

    <cffile action="upload"
            filefield   ="Image"
            destination ="#path#"
            nameconflict="makeunique"
            accept      ="image/jpeg,image/jpg,image/png"
            result      ="uploadresult"
 />
            <!--- <cfdump var="#uploadresult#" /> --->
            <cfset VARIABLES.image = "#uploadresult.SERVERFILE#" />

            <cfset newProduct = productCFC.addNewProduct(form = FORM, imageName = VARIABLES.image ) />

            <cflocation url="#cgi.HTTP_REFERER#" addtoken="false" />


            <!--- <cfset adminCFC = createObject("cfc.admin") />
            <cfset productAdd = adminCFC.addProduct(#FORM#,#image#)/>
            <cfdump var="#productAdd#"> --->

</cfif>

<cfcatch type="any">
    <cfdump var="#cfcatch#" />
</cfcatch>
</cftry>