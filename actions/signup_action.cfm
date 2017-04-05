<cfif StructKeyexists(Form, "signup")>

  <cfif isValid('string', form.FirstName)>
    <cfif isValid('email', form.Email)>

        <!---
        <cfset user_id = form.FirstName />
        <cfset password = form.Password />
        <cfset crypto = createObject('component', 'Crypto') />
        <cfset salt = crypto.genSalt() />
        <cfset passwordHash = crypto.computeHash(password,salt) />
        --->

       	   <cfquery name="signup" >
       		   INSERT INTO [User]
             (FirstName, LastName, Email,	PhoneNo, 	Password, Role)
       		    VALUES
            ( <cfqueryparam value = "#Form.FirstName#" cfsqltype="varchar" > ,
              <cfqueryparam value = "#form.LastName#" >,
              <cfqueryparam value = "#form.Email#" cfsqltype="varchar" >,
              <cfqueryparam value = "#form.PhoneNo#" cfsqltype="varchar" >,
              <cfqueryparam value = "#form.Password#" cfsqltype="varchar" >,
              'user'
            )
            </cfquery>
            <cfoutput>
              <h3>Account Created Successfully</h3>
              <a href="./../index.cfm">click here to go to homepage</a>
              <a href="#cgi.HTTP_REFERER#">click here to go to signup page</a>
            </cfoutput>
        <cfelse>
          <h3>Invalid email</h3>
        </cfif>
      <cfelse>
        <h3>Invalid FirstName</h3>
      </cfif>
    <cfelse>
    </cfif>
