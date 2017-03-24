<!DOCTYPE html>
<html>
<head>
    <script src="assets/js/productDetail.js"></script>
    <cfinclude template = "assets/libraries/libraries.cfm">


    <script>
    </script>
</head>
<body>

<div id="header"><cfinclude template = "commons/header.cfm" /></div>

<!---   [tobe designed] / [WORKED UPON]
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


    <cfif StructKeyExists(URL, "pid")>
        <cfset pid="#url.pid#" />

        <cfquery name="productdetails">
            SELECT p.* , b.BrandName
            FROM [Product] p
            INNER JOIN [Brand] b
            ON p.BrandId = b.BrandId
            WHERE p.ProductId = <cfqueryparam value = "#pid#" CFSQLType = "[cf_sql_integer]">
        </cfquery>

        <cfif productdetails.recordCount> <!--- Product Exists --->
            <cfoutput>
                    #productdetails.BrandName# - #productdetails.Name# #productdetails.ListPrice#

            <!--- check for if already in cart  --->
            <cfif session.loggedin>
                <cfquery name="incart">
                    SELECT * from [Cart]
                    Where UserId = #session.user.userid# AND ProductId = #pid#
                </cfquery>
                <cfif incart.recordCount>
                    <span id="gotocart_btn">    <!--- Show Go To Cart button --->
                    <button type="button" value="##" onclick="window.location.href='cart.cfm';" class="btn btn-sm btn-primary verdana"><span class="glyphicon glyphicon"></span> Go To Cart</button>
                    </span>
                <cfelse>
                    <span id="addtocart_btn">  <!--- Show Add to cart  button --->
                    <button type="button" value="#pid#" onclick="addToCart(this);changeto_gotocart();" class="btn btn-sm btn-primary verdana"><span class="glyphicon glyphicon-shopping-cart"></span> Add to Cart</button>
                    </span>
                </cfif>                         <!--- Show Buy Now Button --->
                    <button type="button" value="#pid#" onclick="checkOut(this,#session.user.userid#);" class="btn btn-sm btn-success verdana"><span class="glyphicon glyphicon-usd"></span> Buy Now</button>
            <!---not logged in --->
            <cfelse>
                <cfif ArrayContains(session.cart , #pid#)>
                    <span id="gotocart_btn">
                    <button type="button" value="##" onclick="window.location.href='cart.cfm';" class="btn btn-sm btn-primary verdana"><span class="glyphicon glyphicon"></span> Go To Cart</button>
                    </span>
                <cfelse>
                    <span id="addtocart_btn">
                    <button type="button" value="#pid#" onclick="addToCart(this);changeto_gotocart();" class="btn btn-sm btn-primary verdana"><span class="glyphicon glyphicon-shopping-cart"></span> Add to Cart</button>
                    </span>
                </cfif>
                <button type="button" value="#pid#" onclick="checkOut(this,undefined);" class="btn btn-sm btn-success verdana"><span class="glyphicon glyphicon-usd"></span> Buy Now</button>
            </cfif>


            </cfoutput>
        <cfelse>  <!--- Product Not found for the provided pID --->
            <h3 class="text text-danger">Error Getting Product Details</h3>
        </cfif>
    <cfelse>
        <cflocation url = "index.cfm" addToken="false">
    </cfif>

<cfinclude template = "commons/footer.cfm">
</body>
</html>
