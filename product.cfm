<!DOCTYPE html>
<head>
    <cfinclude template = "assets/libraries/libraries.cfm">
    <link href="assets/css/product.css" rel="stylesheet">
    <script src="assets/js/product.js"></script>
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

            <div class="container-fluid">

                <div class="filter">
                    under construction..
                </div>
                <!--- <div id="product_listing"> --->
                <!--- show product category wise --->
                <div class="products">
                <cfif StructKeyExists(URL, "cat") AND StructKeyExists(URL, "scat")>
                    <cfset productCFC = createObject("cfc.product") />
                    <cfset productsQuery = productCFC.getProductsForSubCat(scat = #URL.scat#) />

                        <cfif productsQuery.recordCount>
                            <cfoutput>
                                <cfloop query = "productsQuery">
                                    <div class="product">
                                        <a href="productDetails.cfm?pid=#ProductId#"></a>
                                        <div class="product_image">
                                            <img class="" src="assets/images/products/medium/#Image#" width="200px">
                                        </div>
                                        <div class="product_content">
                                            <div class="product_name"> #Name# </div>
                                            <ul>
                                                #Description#
                                            </ul>
                                            <div class="product_pricing">
                                                <div class="product_price"> #ListPrice#  </div>
                                                <div class="product_discounted_price">#DiscountPercent#</div>
                                            </div>
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
                        <!--- <cflocation url = "index.cfm" addToken="false"> --->
                </cfif>
                </div>
        </div>


<cfinclude template = "commons/footer.cfm">
</body>
</html>
