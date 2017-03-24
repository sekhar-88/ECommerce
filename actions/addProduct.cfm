<!--- <cfparam name="form.Name" default=""/>
<cfparam name="form.BrandId" default=""/>
<cfparam name="form.SubCategoryId" default=""/>
<cfparam name="form.SupplierId" default=""/>
<cfparam name="form.ListPrice" default=""/>
<cfparam name="form.Qty" default=""/>
<cfparam name="form.Description" default=""/>
<cfparam name="form.Image" default=""/>
 --->
<cfdump var="#file#" />
<cftry>
    <cfif len(trim(form.Image))>
        <cffile action="upload"
                fileField="Image"
                destination="E:\EclipseWorkSpace\ColdFusion\Project\assets\images\products\medium"
                nameconflict="error"
                result="uploadResult" >

        <cfoutput>#serializeJSON(uploadResult)#</cfoutput>
        <cfoutput><p>Thankyou, your file has been uploaded.</p></cfoutput>
        <cfelse>
        <p>file has not been uploaded</p>
    </cfif>
<cfcatch>
    <cfdump var="#cfcatch#" />
</cfcatch>
</cftry>
URL:
<cfdump var="#URL#"/>
POST:
<cfdump var="#form#" />
<!--- <cftry>
    <cfdump var="#this#" />
    <cfif len(trim(form.Image))>
        <cffile action="upload"
        fileField="fileUpload"
        destination="D:\docs">
        <p>Thankyou, your file has been uploaded.</p>
        <cfelse>
            <p>file has not been uploaded</p>
        </cfif>
    <cfcatch >
            <cfdump var="#cfcatch#">
    </cfcatch>
</cftry> --->
