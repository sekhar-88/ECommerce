<!--- this page is for testing purpose ... & hence not used anywhere  --->

<!--- <cfoutput>
    <h3>this file logs in the main user Automatically.<h3>
        User caution!
</cfoutput>
<cfif session.loggedin>
    <cfdump var="#session#" />
<cfelse>
    <cfquery name="result" result="userQuery">
        select UserId,FirstName,LastName,Email,PhoneNo from [User]
        Where Email= 'cs09.fb@gmail.com'
        AND Password= 'mindfire'
    </cfquery>

    <cfset session.User = {
        UserId = "#result.UserId#",
        UserName = "#result.FirstName#" & " " & "#result.LastName#",
        UserEmail = "#result.Email#",
        userPhoneNo = "#result.PhoneNo#"
        } />
        <cfset session.loggedin="true" />
        <cfset session.cart = arrayNew(1) />
        <cfdump var="#session#" />
        <!--- <cfdump var="#cookie#" /> --->
</cfif> --->




<!--- looping over array --->



<!--- this works in coldfusion 2016 --->
<!---
<cfset myArray = ["John", "Paul", "George", "Ringo"] >
<cfloop array="#myArray#" index="name" item="Beatles">
   <cfoutput>#name# : #Beatles#  </cfoutput>
</cfloop>
 --->







<!--- <cfinclude template="/include/libraries.cfm" />

<script src="../assets/js/header.js"></script>
<link href="../assets/css/header.css" rel="stylesheet">

<!--- this works in coldfusion 10 --->
<cfset myArray = ["John", "Paul", "George", "Ringo"] >
<cfloop array="#myArray#" index="name">
   <cfoutput> #name#  </cfoutput>
</cfloop>

calculating password hash

<cfquery name="CalculateHashForAllUsers">
    SELECT Password
    FROM [User]
</cfquery>


<button type="button" onclick="generate();">generate Notification</button>
<script>
function generate(){
    notify("text alert", "success");
}
</script> --->






<!--- This updates the password Hash from the Plain passwordboxes --->
<!--- <cfquery name = "password">
    SELECT UserId, Password, PasswordHash FROM [User]
</cfquery>
<cfdump var="#password#" />

<cfquery name="updateHash">
    <cfloop query="#password#">
        update [User]
        SET PasswordHash = '#HASH(password.Password)#'
        WHERE UserId = #password.UserId#
    </cfloop>
</cfquery>
<cfdump var="#updateHash#" />

<cfquery name = "password">
    SELECT Password,PasswordHash FROM [User]
</cfquery>
<cfdump var="#password#" /> --->



<cfinclude template="/commons/header.cfm" />
<script>
    $().ready(function(){
        showUpdateModal("test", 2000);
    })
</script>



<cfinclude template="/commons/footer.cfm" />
