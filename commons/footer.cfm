<!DOCTYPE html>
<html>

<head>

	<meta charset="utf-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<!--- <meta name="viewport" content="width=device-width, initial-scale=1"> --->
	<!--- <meta name="keywords" content="footer, address, phone, icons" /> --->

	<title>Footer With Address And Phones</title>

	<!--- <link rel="stylesheet" href="css/demo.css"> --->
	<link rel="stylesheet" href="assets/css/footer-distributed-with-address-and-phones.css">

	<!--- <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.2.0/css/font-awesome.min.css"> --->

	<link href="http://fonts.googleapis.com/css?family=Cookie" rel="stylesheet" type="text/css">

</head>

	<body>

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

				<h3>Company<span>logo</span></h3>

				<p class="footer-links">
					<a href="index.cfm">Home</a>
					·
					<a href="#">Blog</a>
					·
					<a href="#">Pricing</a>
					·
					<a href="#">About</a>
					·
					<a href="#">Faq</a>
					·
					<a href="#">Contact</a>
				</p>

				<p class="footer-company-name">Company Name &copy; 2015</p>
			</div>

			<div class="footer-center">

				<div>
					<i class="fa fa-map-marker"></i>
					<p><span>21 Revolution Street</span> Paris, France</p>
				</div>

				<div>
					<i class="fa fa-phone"></i>
					<p>+1 555 123456</p>
				</div>

				<div>
					<i class="fa fa-envelope"></i>
					<p><a href="mailto:support@company.com">support@company.com</a></p>
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

	</body>

</html>
