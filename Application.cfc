<cfcomponent
    displayname = "Application"
    output = "true"
    hint = "handle the shopping project" >

    <cfset this.Name = "Shopping" />
    <cfset this.sessionManagement = true />
    <!--- <cfset this.setClientCookies = false /> --->
    <cfset this.applicationTimeout = CreateTimeSpan(0,0,1,0) />
    <cfset this.sessionTimeout = CreateTimeSpan(0,0,30,0) />
    <cfset this.datasource = "eShoppingBasic" />
    <cfset this.rootDir = #server.ColdFusion.RootDir# />
    <cfset this.mappings["/project"] = getDirectoryFromPath(getCurrentTemplatePath()) />

    <cfsetting
        enablecfoutputonly = "no"
        requesttimeout = "20"
        showdebugoutput = "yes" />



    <cffunction name="OnApplicationStart"
            access="public"
            returntype="boolean"
            output="false"
            hint="Fires when the application is first created." >

            <!--- Return out. --->
            <cfreturn true />
    </cffunction>

    <cffunction name = "onSessionStart"
        access = "public"
        returntype = "void"
        output = "false"
        hint = "fires when the session is first created." >

        <cfset session.loggedin = false />
        <cfset session.cart = [] />
        <cfset session.cartDataChanged = false />
        <cfset session.User = { role = "guest" } />


        <cfreturn />
    </cffunction>

    <cffunction name = "OnRequestStart"
        access = "public"
        returnType = "boolean"
        output = "false"
        hint = "Fires at first part of page processing." >

        <cfargument
            name = "TargetPage"
            type = "string"
            required = "true"
            />
        <!--- <cfdump var="#REQUEST#" /> --->

        <cfreturn true />
    </cffunction>

    <cffunction name = "OnRequest"
        access = "public"
        returntype = "void"
        output = "true"
        hint = "fires after pre page processing is complete" >

        <cfargument
            name = "TargetPage"
            type = "string"
            required = "true"
            />
        <!--- <cfdump var="#REQUEST#" /> --->

        <cfinclude template = "#ARGUMENTS.targetpage#" />
        <cfreturn />
    </cffunction>

    <!--- <cffunction name = "OnRequestEnd"
        access = "public"
        returntype = "void"
        output = "true"
        hint = "Fires after the page processing is complete." >

        <cfreturn />
    </cffunction> --->

    <cffunction name = "OnSessionEnd"
        access = "public"
        returntype = "void"
        output = "false"
        hint = "Fires when the session is terminated." >

        <cfargument
            name = "SessionScope"
            type = "struct"
            required = "true"
            />

         <cfargument
            name = "ApplicationScope"
            type = "struct"
            required = "false"
            default = "#StructNew()#"
            />

        <cfreturn />
    </cffunction>

    <cffunction name = "OnApplicationEnd"
        access = "public"
        returntype = "void"
        output = "false"
        hint = "Fires when the application is terminated." >

        <cfargument
            name = "ApplicationScope"
            type = "struct"
            required = "false"
            defaut = "#StructNew()#"
            />

        <cfreturn />
    </cffunction>

    <cffunction name = "OnError"
        access = "public"
        returntype = "void"
        output = "true"
        hint = "Fires when an exception occures that is not caught by a try/catch" >

        <cfargument
            name = "Exception"
            type = "any"
            required = "true"
            />

        <cfargument
            name = "EventName"
            type = "string"
            required = "false"
            default = ""
            />

            <cfdump var="#ARGUMENTS.Exception#" />
            <cfdump var="#ARGUMENTS.EventName#" />
            <!--- WriteLog(type="Error", file="shoppingbuzz.log", text="[#arguments.exception.type#] #arguments.exception.message#") --->

        <cfreturn />
    </cffunction>


</cfcomponent>
