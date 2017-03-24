<cfcomponent>

    <cffunction  name="isCartEmpty" output="false" returntype="boolean"  returnFormat="json" access="remote">
        <cfif session.loggedin>
            <cfquery name="items">
                SELECT CartId
                FROM [Cart]
                WHERE UserId = #session.User.UserId#
            </cfquery>
            <cfif items.recordcount>
                <cfset result = "false"/>
                <cfelse>
                <cfset result = "true" />
            </cfif>
        <cfelse>
            <cfset result = ArrayIsEmpty(session.cart)/>
        </cfif>

        <cfreturn #result#/>
    </cffunction>

    <cffunction name="removeFromUserCart" output="true" returntype="boolean" returnformat="json" access="remote">
        <cfargument name="pid" type="numeric" required="true" />
        <cfset uid = #session.user.userid#/>
            <cftry>
                <cfquery name="removeItem">
                    DELETE
                    FROM [Cart]
                    WHERE ProductId = #arguments.pid# AND UserId = #uid#
                </cfquery>
                <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->
                <cfreturn true/>
            <cfcatch>
                <cfreturn false/>
            </cfcatch>
            </cftry>
    </cffunction>

    <cffunction name="removeFromSessionCart" output="false" returnType="boolean" returnFormat="json" access="remote" >
        <cfargument name="pid" type="numeric" required="true"/>
            <cftry >
                <cfset arrayDelete(session.cart, #arguments.pid#) />
                <cfset session.cartDataChanged = true/> <!---for resetting checkout step --->
                <cfreturn true/>
            <cfcatch >
                <cfreturn false/>
            </cfcatch>
            </cftry>
    </cffunction>
</cfcomponent>
