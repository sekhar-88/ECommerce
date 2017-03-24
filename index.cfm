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
            <cfoutput>
                show page carousel
            </cfoutput>
    </cfif>
</div>

<cfinclude template = "commons/footer.cfm">
</body>
</html>
