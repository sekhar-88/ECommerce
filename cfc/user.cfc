<cfcomponent>
    <cffunction name="isUserLogggedin" returntype="boolean" returnFormat="json" access="remote" >
        <cfif session.loggedin>
            <cfreturn true/>
            <cfelse>
                <cfreturn false/>
        </cfif>

    </cffunction>
    <cffunction output="false" name="getLoggedUser" returnType="string"  returnFormat="json" access="remote">
        <!--- Returns If a user is logged in or not. IF loggedin then his userid --->
        <cfif session.loggedin>
            <cfset user = {"userid" = "#session.User.UserId#",
                            "loggedin" = "true"} />
        <cfelse>
            <cfset user = { "loggedin" = "false" } />
        </cfif>

        <cfset userS = serializeJSON(#user#) />
        <cfreturn #userS#/>
    </cffunction>

    <cffunction name="validate" access="remote" output="false" returntype="struct" returnFormat="json">
        <cfargument name="email" type="string" required="true">
        <cfargument name="password" type="string" required="true">

            <cfset response = {
                    "status" = "true",
                    "errortype" = ""
                }/>

                <cfquery name="findUser">
                    <!--- dont query password, query for password salt --->
                    SELECT UserId,Password
                    FROM [User]
                    WHERE Email = <cfqueryparam value = "#arguments.email#" CFSQLType="cf_sql_varchar" >
                </cfquery>

                <cfif findUser.recordcount>

                    <cfif findUser.Password EQ ARGUMENTS.password>   <!--- login success --->

                        <cfquery name="result" result="userQuery">
                            select UserId,FirstName,LastName,Email,PhoneNo,Role from [User]
                            Where Email=<cfqueryparam value="#arguments.email#" CFSQLType="cf_sql_varchar">
                                AND Password=<cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar">
                        </cfquery>

                        <cfset session.User = {
                            UserId = "#result.UserId#",
                            UserName = "#result.FirstName#" & " " & "#result.LastName#",
                            UserEmail = "#result.Email#",
                            UserPhoneNo = "#result.PhoneNo#",
                            Role = "#result.Role#"
                            } />
                            <cfset session.loggedin="true" />
                            <cfset session.User.checkout = { step = 0 }/>  <!--user has not checked out items --->

                            <!--- add session items to user cart --->
                            <cfset productCFC = createObject("product")/>
                            <cfloop index="pid" array="#session.cart#" >
                                <cfset added_to_cart = productCFC.addToCart(pid)/>
                            </cfloop>

                            <cfset response.status = "true" />

                    <cfelse>
                        <cfset response.status = "false" />
                        <cfset response.errortype = "password" />
                    </cfif>

                <cfelse>
                    <cfset response.status = "false">
                    <cfset response.errortype = "email" >
                </cfif>

                <cfreturn #response# />
    </cffunction>

</cfcomponent>
