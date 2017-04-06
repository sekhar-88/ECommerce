<cfcomponent>
    <cfset VARIABLES.productModel = CreateObject("cfc.product")/>

    <cffunction name="isProductInCart" returntype = "boolean" access = "remote" >
        <cfargument name = "pid" type = "numeric" required = "true" />

        <cfinvoke method="isProductInCart" component="#VARIABLES.productModel#"
            returnvariable="LOCAL.response" argumentcollection="#ARGUMENTS#" />

        <cfreturn #LOCAL.response#/>
    </cffunction>

</cfcomponent>
