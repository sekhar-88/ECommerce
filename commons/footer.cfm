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

		<!--- <header>

			<h1>Freebie: 5 Responsive Footer Templates</h1>
			<h2><a href="http://tutorialzine.com/2015/01/freebie-5-responsive-footer-templates/">Download</a></h2>

			<ul>
				<li><a href="index.html">Basic Centered</a></li>
				<li><a href="footer-distributed.html">Distributed</a></li>
				<li><a href="footer-distributed-with-address-and-phones.html" class="active">Distributed With Address And Phones</a></li>
				<li><a href="footer-distributed-with-contact-form.html">Distributed With Contact Form</a></li>
				<li><a href="footer-distributed-with-search.html">Distributed With Search</a></li>
			</ul>

		</header> --->

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
