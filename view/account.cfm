<!DOCTYPE html>
<html>
<head>
  <title>#session.user.username#</title>
  <cfinclude template = "/include/libraries.cfm">
</head>
<body>
    <cfinclude template="/commons/header.cfm" />
    <cfif session.loggedin>
        <h3>Under Construction..</h3>
    <cfelse>
        <cflocation url="index.cfm" addtoken="false" />
    </cfif>

    <cfinclude template="/commons/footer.cfm" />
</body>
</html>
