<!---
	Page Name: footer.cfm
	it is a commons file which gets displayed at the end of every page of the shopping site.
	it shows a link to admin section while an admin is logged in.
--->


<head>

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!--- <meta name="viewport" content="width=device-width, initial-scale=1"> --->
	<!--- <meta name="keywords" content="footer, address, phone, icons" /> --->

	<!--- <link rel="stylesheet" href="css/demo.css"> --->
	<link rel="stylesheet" href="../assets/css/footer-distributed-with-address-and-phones.css">

	<!--- <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css"> --->

	<!--- <link href="http://fonts.googleapis.com/css?family=Cookie" rel="stylesheet" type="text/css"> --->

</head>

<!--- refreshing / updating show modal..  function is defineds as showUpdateModal(message, delay, icon) --->
	<div class="modal fade" id="refresh-modal" role="dialog">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-header">
  					<button type="button" class="close" data-dismiss="modal">&times;</button>
  					<h4 class="modal-title">updating..</h4>
				</div>

				<div class="modal-body">
					<h5 align="center"><i class="icon"></i><h5>
					<h5 class="update-message"></h5>
					<span class="sr-only">Loading...</span>
				</div>

				<div class="modal-footer">
  					<button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
				</div>
			</div>
		</div>
	</div>
		<!-- The content of your page would go here. -->
		<footer class="footer-distributed">

			<cfif session.loggedin>
				<cfif session.User.Role EQ 'admin'>
					<p align="center"><a class="admin-panel-notice" href="section_admin.cfm">Go To Admin Panel</a></p>
				</cfif>
			</cfif>

			<div class="footer-left">

				<h3>Shopping<span>BUZZ</span></h3>

				<p class="footer-links">
					<a href="index.cfm">Home</a>
					&#8226;
					<a href="#">Blog</a>
					&#8226;
					<a href="#">Pricing</a>
					&#8226;
					<a href="#">About</a>
					&#8226;
					<a href="#">Faq</a>
					&#8226;
					<a href="#">Contact</a>
				</p>

				<p class="footer-company-name">shoppingBuzz &copy; 2017</p>
			</div>

			<div class="footer-center">

				<div>
					<i class="fa fa-map-marker"></i>
					<p><span>DLF Cybercity</span> Bhubaneswar, Odisha, India</p>
				</div>

				<div>
					<i class="fa fa-phone"></i>
					<p>+91 7504 785308</p>
				</div>

				<div>
					<i class="fa fa-envelope"></i>
					<p><a href="mailto:cs09.fb@gmail.com">ChandraSekhar@gmail.com</a></p>
				</div>
			</div>

			<div class="footer-right">

				<p class="footer-company-about">
					<span>About the company</span>
					Shoppingbuzz. Your one  &amp; only destimation for Fashions &amp; other accessories...a simple eShopping Site by Chandra Sekhar Sahoo. Made for the Project Purpose &amp; &copy;ShoppingBUZZ.com 2017

				</p>

				<div class="footer-icons">

					<a href="#"><i class="fa fa-facebook"></i></a>
					<a href="#"><i class="fa fa-twitter"></i></a>
					<a href="#"><i class="fa fa-linkedin"></i></a>
					<a href="#"><i class="fa fa-github"></i></a>

				</div>

			</div>

		</footer>




<!---
	SERVER CODES for CHECKING LOGOUT CLICKED OR NOT.
--->

		<cfif StructKeyExists(FORM, "LOGOUT")>

		    <cfset structClear(SESSION.User) />

		    <!--- <cfset StructDelete(SESSION, "CFTOKEN")/>
		    <cfset StructDelete(SESSION, "CFID" )/>
		    <cfcookie name="CFID" expires="now" />
		    <cfcookie name="CFTOKEN" expires="now" /> --->

		    <cfset session.loggedin = "false" />
			<cfset sessionRotate() />
			<cflocation url="#cgi.HTTP_REFERER#" addtoken="false" />
		</cfif>
