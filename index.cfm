<!DOCTYPE html>
<html>
<head>
  <title>eShopping</title>
  <cfinclude template = "assets/libraries/libraries.cfm" />
  <link href="assets/css/index.css" rel="stylesheet">
  <script src="assets/js/index.js"></script>
  <style>

  </style>
</head>
<body>
<div id="header"><cfinclude template = "commons/header.cfm"></div>

<div class="container-fluid-parent">
    <cfif StructKeyExists(URL, "q")>
        <cfquery name = "searchResult">
            select *
              from [Product]
             where Name LIKE '%#URL.q#%'
        </cfquery>
        <cfoutput>
            <p id="product-count-show"> #searchResult.recordCount# Results </p>
            <br />

            <div class="container-fluid">
            <cftry>

            <cfif searchResult.recordCount>
                <div class="filters">
                    <div class="filter filter-Category">
                        <div class="filter-header">Category</div>

                        <form id="category-checkbox">

                        <cfquery name="subcats">
                            SELECT DISTINCT psc.SubCategoryName, psc.SubCategoryId
                            FROM [ProductSubCategory] psc
                            INNER JOIN [Product] p
                            ON psc.SubCategoryId = p.SubCategoryId
                            WHERE p.Name LIKE '%#URL.q#%'
                        </cfquery>

                        <cfoutput>
                        <cfloop query="subcats">
                            <div style="padding: 10px;" class="checkbox">
                                <label><input type="checkbox" name="checkbox" value="#subcats.SubCategoryId#" > #subcats.SubCategoryName#</label>
                            </div>
                        </cfloop>
                        </cfoutput>

                        </form>
                    </div>

                    <div class="filter filter-price">
                        <div class="filter-header">Price</div>
                        <form id="filter-price">

                        </form>

                    </div>
                    <div class="filter filter-other">
                        <div class="filter-header"></div>
                    </div>
                </div>

                <div class="products">
                        <cfloop query="searchResult">
                            <div class="product scat_#SubCategoryId#">
                                <a href="productDetails.cfm?pid=#ProductId#"></a>
                                <div class="product_image">
                                    <img class="" src="assets/images/products/medium/#Image#">
                                </div>
                                <div class="product_content">
                                    <div class="product_name"> #Name# </div>
                                    <div class="product_pricing">
                                        <div class="product_price">#ListPrice#</div>
                                        <div class="product_discounted_price">#DiscountPercent#</div>
                                    </div>
                                    <ul>
                                        <!--- <cfloop index="i" list="#Description#" delimiters="`"  >
                                            <li>#i#</li>
                                        </cfloop> --->
                                    </ul>
                                </div>
                            </div>
                        </cfloop>
                </div>
            <cfelse>
                <div class="no-products">
                    no products
                </div>
        </cfif>
        <cfcatch>
        <cfdump var="#cfcatch#" />
        </cfcatch>
        </cftry>
        </cfoutput>



    <cfelse>   <!--- home page section --->
        <div class="container-fluid">
            <div class="carousel-container">
                <div id="myCarousel" class="carousel slide" data-ride="carousel">
                      <!-- Indicators -->
                      <ol class="carousel-indicators">
                        <li data-target="#myCarousel" data-slide-to="0" class="active"></li>
                        <li data-target="#myCarousel" data-slide-to="1"></li>
                        <li data-target="#myCarousel" data-slide-to="2"></li>
                        <!--- <li data-target="#myCarousel" data-slide-to="3"></li> --->
                      </ol>

                      <!-- Wrapper for slides -->
                      <div class="carousel-inner" role="listbox" style="height: 400px;">

                        <div class="item active">
                          <a href="product.cfm?cat=2&amp;scat=3"><img src="assets/images/products/featured/frontpagecarousel/mensfashion.jpg" alt="mensfashion"></a>
                        </div>

                        <div class="item">
                          <a href="product.cfm?cat=1&amp;scat=1"><img src="assets/images/products/featured/frontpagecarousel/mensfootwear.jpg" alt="mensfootwear"></a>
                        </div>

                        <div class="item">
                            <a href=""><img src="assets/images/products/featured/frontpagecarousel/casualstyle.jpg" alt="casualstyle"></a>
                        </div>

                        <!--- <div class="item">
                          <img src="assets/images/products/featured/frontpagecarousel/menstshirts.jpg" alt="menstshirts">
                        </div> --->

                      </div>

                      <!-- Left and right controls -->
                      <a class="left carousel-control" href="#myCarousel" role="button" data-slide="prev">
                        <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
                        <span class="sr-only">Previous</span>
                      </a>
                      <a class="right carousel-control" href="#myCarousel" role="button" data-slide="next">
                        <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
                        <span class="sr-only">Next</span>
                      </a>
                </div>
            </div>
        </div>
    </cfif>
</div>

<cfinclude template = "commons/footer.cfm">
</body>
</html>
