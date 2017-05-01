<!---
    Page Name: Account.cfm
    view account related informations in this page
    edit user details etc...
--->

<!DOCTYPE html>
<html>
<head>
  <title>#session.user.username#</title>
</head>

<body>
    <div class="page-header"><cfinclude template = "/commons/header.cfm" /></div>

    <div class="page-container-fluid">
        <cfif session.loggedin>
            <h3>Under Construction..</h3>
        <cfelse>
            <cflocation url="index.cfm" addtoken="false" />
        </cfif>
    </div>

    <cfinclude template="/commons/footer.cfm" />
</body>
</html>
