<cfcomponent>

    <cffunction name = "getUserPassword" returntype = "query" access = "public" >
        <cfargument name="email" type="string" required="true">
        <cfargument name="password" type="string" required="true">

        <cfquery name="REQUEST.findUser">
            <!--- dont query password, query for password salt --->
            SELECT UserId,Password
            FROM [User]
            WHERE Email = <cfqueryparam value = "#arguments.email#" CFSQLType="cf_sql_varchar" >
        </cfquery>

        <cfreturn #REQUEST.findUser#/>
    </cffunction>


    <cffunction name="getUserDetails" returntype="query" access = "public" >
        <cfargument name="email" type="string" required="true">
        <cfargument name="password" type="string" required="true">

        <cfquery name="REQUEST.result" result="userQuery">
            SELECT UserId,FirstName,LastName,Email,PhoneNo,Role from [User]
            WHERE Email=<cfqueryparam value="#ARGUMENTS.email#" CFSQLType="cf_sql_varchar">
                AND Password=<cfqueryparam value="#ARGUMENTS.password#" CFSQLType="cf_sql_varchar">
        </cfquery>

        <cfreturn #REQUEST.result#/>
    </cffunction>

</cfcomponent>
