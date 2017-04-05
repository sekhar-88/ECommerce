<cfcomponent extends="product" >
    <cfset VARIABLES.userDB = CreateObject("db.user_db")/>

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
            <cfset user = {
                "userid" = "#session.User.UserId#",
                "loggedin" = "true"
                } />
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

                <cfinvoke method="getUserPassword" component="#VARIABLES.userDB#"
                    returnvariable="REQUEST.findUser" argumentcollection="#ARGUMENTS#"  />

                <cfif REQUEST.findUser.recordcount>

                    <cfif REQUEST.findUser.Password EQ ARGUMENTS.password>   <!--- login success --->

                        <cfinvoke method="getUserDetails" component="#VARIABLES.userDB#"
                            returnvariable="REQUEST.result" argumentcollection="#ARGUMENTS#"  />

                        <cfset session.User = {
                            UserId = "#REQUEST.result.UserId#",
                            UserName = "#REQUEST.result.FirstName#" & " " & "#REQUEST.result.LastName#",
                            UserEmail = "#REQUEST.result.Email#",
                            UserPhoneNo = "#REQUEST.result.PhoneNo#",
                            Role = "#REQUEST.result.Role#"
                            } />

                            <cfset SESSION.loggedin="true" />
                            <cfset SESSION.User.checkout = { step = 0 }/>  <!--user has not checked out items --->

                            <!--- add session items to user cart --->
                            <cfloop index="i" item = "pid" array="#SESSION.cart#" >
                                <cfset SUPER.addToCart(#pid#)/>
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
