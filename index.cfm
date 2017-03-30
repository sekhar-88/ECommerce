<!DOCTYPE html>
<html>
<head>
  <title>eShopping</title>
  <cfinclude template = "assets/libraries/libraries.cfm" />
  <script src="assets/js/index.js"></script>
  <style>

  </style>
</head>
<body>
<div id="header"><cfinclude template = "commons/header.cfm"></div>

<div class="container-fluid">
    <cfif StructKeyExists(URL, "q")>
        <cfquery name = "searchResult">
            select Name
              from [Product]
             where Name LIKE '%#URL.q#%'
        </cfquery>
        <cfoutput>
            #searchResult.recordCount# Results <br />
            <cfif searchResult.recordCount>
                <cfloop query="searchResult">
                    <div class="product_search">
                        <div class="product_image">
                        </div>
                        <div class="product_info">
                            #searchResult.Name#
                        </div>
                    </div>
                </cfloop>
            </cfif>
        </cfoutput>
    <cfelse>
            <div class="container carousel-container">
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
                          <a href="product.cfm?cat=1&amp;scat=1"><img src="assets/images/products/featured/frontpagecarousel/mensfootwear.jpg" style="margin:auto; height: 400px; widht: 100%" alt="mensfootwear"></a>
                        </div>

                        <div class="item">
                            <a href=""><img src="assets/images/products/featured/frontpagecarousel/casualstyle1.jpg" style="margin:auto; height: 400px; widht: 100%" alt="casualstyle"></a>
                        </div>

                        <div class="item">
                          <a href="product.cfm?cat=2&amp;scat=3"><img src="assets/images/products/featured/frontpagecarousel/mensfashion1.jpg" style="margin:auto; height: 400px; widht: 100%" alt="mensfashion"></a>
                        </div>

                        <div class="item">
                          <img src="assets/images/products/featured/frontpagecarousel/menstshirts.jpg" style="margin:auto; height: 400px; widht: 100%" alt="menstshirts">
                        </div>

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
    </cfif>
</div>

<cfinclude template = "commons/footer.cfm">
</body>
</html>
