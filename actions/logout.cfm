<cfdump var="#FORM#" />
<cfset httpReferrer = #cgi.HTTP_REFERER# />
<cfif StructKeyExists(FORM, "LOGOUT")>


    <cfset structClear(SESSION.User) />

    <!--- <cfset StructDelete(SESSION, "CFTOKEN")/>
    <cfset StructDelete(SESSION, "CFID" )/>
    <cfcookie name="CFID" expires="now" />
    <cfcookie name="CFTOKEN" expires="now" /> --->

    <cfset session.loggedin = "false" />
    <cfoutput> Successfully Loggedout!</cfoutput>
    <cflocation url="#httpReferrer#" addtoken="false" />
</cfif>
