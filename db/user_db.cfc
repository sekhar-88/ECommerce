<cfcomponent>

<!---
    this function checks for existting emails in the db
    search for existing emails while signing up for a new account
--->
    <cffunction name="searchExistingEmails" returntype="boolean" access="public" >
        <cfargument name="email" type="string" required="true" />
        <cfset LOCAL.response = false />

        <cftry>
            <cfquery name="LOCAL.emailExists" >
                 SELECT UserId
                 FROM [User]
                 WHERE Email = <cfqueryparam value = "#ARGUMENTS.Email#" cfsqltype="cf_sql_nvarchar" />
            </cfquery>

            <cfif LOCAL.emailExists.recordCount >
                <cfset LOCAL.response = true />
            </cfif>

            <cfcatch>
                <cfdump var="#cfcatch#" />
            </cfcatch>

        </cftry>

        <cfreturn LOCAL.response />
    </cffunction>



<!---
    User Regestration with storing the details
--->

    <cffunction name = "createUser" returntype = "Any" access = "public"  >
        <cfargument name = "form" type = "struct" required = "true" />

        <cftry>
                <cfquery name = "signup" >
                    INSERT INTO [User]
                        (FirstName, LastName, Email,	PhoneNo, 	Password, PasswordHash, Role)
                    VALUES
                    (
                        <cfqueryparam value = "#ARGUMENTS.form.FirstName#" cfsqltype = "cf_sql_varchar" >,
                        <cfqueryparam value = "#ARGUMENTS.form.LastName#" cfsqltype  = "cf_sql_nvarchar" >,
                        <cfqueryparam value = "#ARGUMENTS.form.Email#" cfsqltype     = "cf_sql_nvarchar" >,
                        <cfqueryparam value = "#ARGUMENTS.form.PhoneNo#" cfsqltype   = "cf_sql_bigint" >,
                        <cfqueryparam value = "#ARGUMENTS.form.Password#" cfsqltype  = "cf_sql_nvarchar">,
                        <cfqueryparam value = "#Hash(ARGUMENTS.form.Password)#" cfsqltype = "cf_sql_nvarchar">,
                        'user'
                    )
                </cfquery>


            <cfcatch type="DATABASE">
                <cfdump var = "#cfcatch#" />
            </cfcatch>
        </cftry>


        <cfreturn true />
    </cffunction>



<!---
this function return userId to validate function in controller for
matching == not existing accounts (email)
        &   not existing
--->
    <cffunction name = "getUserPassword" returntype = "query" access = "public" >
        <cfargument name = "email" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">

        <cfquery name = "LOCAL.findUser">
            <!--- dont query password, query for password salt --->
            SELECT UserId,Password
            FROM [User]
            WHERE Email = <cfqueryparam value = "#ARGUMENTS.email#" CFSQLType = "cf_sql_varchar" >
        </cfquery>

        <cfreturn #LOCAL.findUser#/>
    </cffunction>


    <cffunction name = "getUserDetails" returntype = "query" access = "public" >
        <cfargument name = "email" type = "string" required = "true">
        <cfargument name = "password" type = "string" required = "true">

        <cfquery name = "LOCAL.result" result = "userQuery">
            SELECT UserId,FirstName,LastName,Email,PhoneNo,Role from [User]
            WHERE Email=<cfqueryparam value = "#ARGUMENTS.email#" CFSQLType = "cf_sql_varchar">
                AND Password=<cfqueryparam value = "#ARGUMENTS.password#" CFSQLType = "cf_sql_varchar">
        </cfquery>

        <cfreturn LOCAL.result />
    </cffunction>


</cfcomponent>
