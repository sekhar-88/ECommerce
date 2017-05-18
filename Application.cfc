<!---
    application.cfc for the whole project
--->
<cfcomponent
    displayname = "Application"
    output = "true"
    hint = "handle the shopping project" >

    <cfset THIS.Name = "Shopping" />
    <cfset THIS.sessionManagement = true />
    <cfset THIS.applicationTimeout = CreateTimeSpan(0,0,30,0) />
    <cfset THIS.sessionTimeout = CreateTimeSpan(0,0,10,0) />

    <cfset THIS.datasource = "eShoppingBasic" />
    <cfset THIS.rootDir = getDirectoryFromPath(getCurrentTemplatePath()) />
    <cfset THIS.mappings[ "/project" ] = getDirectoryFromPath(getCurrentTemplatePath()) />
    <cfset THIS.mappings[ "/include" ] = "#THIS.rootDir#assets/libraries/" />
    <cfset THIS.mappings[ "/commons" ] = "#THIS.rootDir#commons/" />

    <!--- <cfset THIS.rootDir = #server.ColdFusion.RootDir# /> --->
    <cfset THIS.db_logfile = "ShoppingDBlog" >
    <cfset APPLICATION.DB_LOGFILE = "ShoppingDBlog" />
    <!--- <cfset THIS.imagePath = "F:\WORK\ColdFusion\Shopping\assets\images\products\medium" /> --->
    <cfset APPLICATION.imagePath = "D:\ShoppingSite\assets\images\products\medium" />

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


        <cfset SESSION.loggedin = false />
        <cfset SESSION.cart = [] />
        <cfset SESSION.cartDataChanged = false />

        <!--- SESSION.User.paymentDataChanged ===

            to check if any new cart data is added or not ...
            for refreshing while placing order ..
            if payment data changed .. it will refresh the page..
            if it is true
            (this is set to false only when user clicks on proceed to payment section) --->
        <cfset SESSION.User = { role = "guest", paymentDataChanged = false } />


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


        <cfinclude template = "/include/libraries.cfm" />
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

            <cfset StructClear(SESSION) />
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

            <cflog file="eShoppingErrorLog"  text="in On Error method, errortype:  #ARGUMENTS.Exception.type#  message: #ARGUMENTS.Exception.message# detail: #ARGUMENTS.Exception.detail#" />


            <cfif #ARGUMENTS.Exception.type# EQ "Expression">
                <cflocation url="index.cfm" addtoken="false" />
            <cfelse>
                <cfinclude template="/commons/error404.cfm" />
            </cfif>

        <cfreturn />
    </cffunction>


    <cffunction name="onMissingTemplate" returnType="boolean">
        <cfargument type="string" name="targetPage" required=true/>
            <cfinclude template="/commons/error404.cfm" />
        <cfreturn false />
    </cffunction>


</cfcomponent>
