<cfcomponent extends="product" >
    <cfset VARIABLES.userDB = CreateObject("db.user_db")/>


<!--- retrns usere logged in or not in ajax --->
    <cffunction name="isUserLogggedin" returntype="boolean" returnFormat="json" access="remote" >
        <cfif session.loggedin>
                <cfreturn true/>
            <cfelse>
                <cfreturn false/>
        </cfif>
    </cffunction>


<!---
    getting the loggedin user in the javascript ajax calls
    Returns If a user is logged in or not. IF loggedin then his userid
--->
    <cffunction output="false" name="getLoggedUser" returnType="string"  returnFormat="json" access="remote">
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




<!---
validate the login useer while logging in
return response
    as email error
    or password error
    depending on the situation
--->
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
                            <cfloop array="#SESSION.cart#"  index="pid">
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


<!---
    creating a new user with provided form fields in ajax
    with validation on server side
    it sends response {status , error }
    status for account creation status & error for which field has error
    like the email field already exists in database
--->
    <cffunction name="newUser" returntype="struct" access="remote"  returnformat="JSON">
        <cfargument name="formSerialized" type="string" required="true" />

        <!--- deseriazed json string object for user registration  --->
        <cfset LOCAL.form = deserializeJSON(ARGUMENTS.formSerialized) />

        <cfset LOCAL.response = {
                    status = true,
                    error = {}
                } />

            <cfif isValid('email', FORM.Email)>
                <cfinvoke method="searchExistingEmails" component="#VARIABLES.userDB#"
                    returnvariable = "REQUEST.emailExists" email = "#LOCAL.form.Email#" />

                <cfif NOT REQUEST.emailExists>
                    <cfinvoke method="createUser" component="#VARIABLES.userDB#"
                        returnvariable = "REQUEST.createUserResponse" form = #LOCAL.form# />

                <cfelse>
                    <!--- email error --->
                    <cfset LOCAL.response.status = false />
                    <cfset structInsert(LOCAL.response.error, 'Email', "This email is already associated with an account") />
                </cfif>

            <cfelse>
                <cfset LOCAL.response.status = false />
                <cfset structInsert(LOCAL.response.error, 'Email', "Enter a valid Email Address") />

            </cfif>

            <cfreturn LOCAL.response />
    </cffunction>


</cfcomponent>
