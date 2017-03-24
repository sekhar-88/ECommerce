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

    <cffunction name="validate" access="remote" output="false" returntype="boolean" returnFormat="json">
            <cfargument name="email" type="string" required="true">
            <cfargument name="password" type="string" required="true">

                <cfquery name="result" result="userQuery">
                    select UserId,FirstName,LastName,Email,PhoneNo,Role from [User]
                    Where Email=<cfqueryparam value="#arguments.email#" CFSQLType="cf_sql_varchar">
                        AND Password=<cfqueryparam value="#arguments.password#" CFSQLType="cf_sql_varchar">
                </cfquery>

                    <cfif result.recordcount GT 0>
                        <cfset session.User = {
                            UserId = "#result.UserId#",
                            UserName = "#result.FirstName#" & " " & "#result.LastName#",
                            UserEmail = "#result.Email#",
                            UserPhoneNo = "#result.PhoneNo#",
                            Role = "#result.Role#"
                            } />
                        <cfset session.loggedin="true" />
                        <cfset session.User.checkout = { step = 0 }/>

                        <!--- add session items to user cart --->
                        <cfset productCFC = createObject("product")/>
                        <cfloop index="pid" array="#session.cart#" >
                            <cfset added_to_cart = productCFC.addToCart(pid)/>
                        </cfloop>


                        <cfreturn true />
                    <cfelse>
                        <cfset session.loggedin="false" />
                        <cfreturn false />
                    </cfif>
    </cffunction>
</cfcomponent>
