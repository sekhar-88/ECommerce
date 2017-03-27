<head>
  <link rel="stylesheet" href="assets/css/header.css">
  <script src="assets/js/header.js"></script>

  <style>
  </style>
</head>

<body onload="updateCartCount();">

<cfset userCFC = createObject("cfc.user") />
<cfset headerCFC = createObject("cfc.header") />
<cfset categories = headerCFC.getCategories() />

	<nav class="navbar navbar-default" style="background-color:#70b6e3;z-index: 500;">       <!-- main navbar type -->
		<div class="container-fluid">         <!-- navbar container -->
			<div class="navbar-header">         <!-- navbar header with contents which show after collapsing -->

				<!-- navigation submenu when windows size changed -->
				<button type="button" class="btn btn-info navbar-toggle collapsed" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
					<span class="sr-only">Toggle Navigation</span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>

				<a class="navbar-brand" href="index.cfm">
					<img class="img" src="assets/images/logo2.png" width="150px"/>
				</a>
			</div>

			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1"> <!--collapsable content -->
				<ul class="nav navbar-nav navbar-left"> <!--for showing men & women's catefories -->

					<li class="dropdown men">
						<a href="##" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Men<span class="caret"></span></a>

						<!--- Men - clicked --->
						<ul class="dropdown-menu list-group">
							<cfloop query="categories">                       <!--looping through category list & displaying categories-->
								<cfoutput>
<!---  Products -  Men  --->           <li class="category disabled" id="cat_#categories.CategoryId#">
									       <span class="category_name">#categories.CategoryName#</span>

                                           <div class="subcat_list_div hideSubCat" style="z-index: 1000;">
<!--- Men -  SubCategory --->              <ul class="subcategory list-group">
                                           <cfset subcategories = headerCFC.getSubCategories(#categories.CategoryId#) />
										   <cfloop query = "subcategories">        <!--looping through subcategory list-->
										      <li class="subcategory_list_li list-group-item" id="subcat_#subcategories.SubCategoryId#">
                                                  <cfset querystr = "cat=#categories.CategoryId#" & "&scat=#subcategories.SubCategoryId#" />
											      <a href="product.cfm?#querystr#">#subcategories.SubCategoryName#</a>
											  </li>
										  </cfloop>
										  </ul>
									      </div>

								       </li>
								</cfoutput>
							</cfloop>
						</ul>
					</li>

					<li class="dropdown women">
						<a href="" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false">Women<span class="caret"></span></a>
						<ul class="dropdown-menu">
							<li><a href="">category1</a></li>
						</ul>
					</li>
				</ul>

				<!---  search bar --->
				<form action="index.cfm" class="navbar-form navbar-left" role="search" method="get">
					<div class="input-group">
						<input type="text" id="product_searchbox" name="q" class="form-control" placeholder="Search Products..">
						<span class="input-group-btn">
                            <button type="submit" class="btn btn-search"><span class="glyphicon glyphicon-search"></span></butotn>
                        </span>
					</div>
				</form>


				<ul class="nav navbar-nav navbar-right">
					<cfif session.loggedin>        <!-- loggedin -->
                        <cfoutput>
						<li class="dropdown">
							<a href="" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-user"></span> #session.User.UserName#</a>
							<ul class="dropdown-menu">
								<li><a href="account.cfm">Account</a></li>
                                <li role="separator" class="separator"></li>
								<li>
									<form method="POST" action="actions/logout.cfm">
										<div class="form-group has-feedback">
											<span class="glyphicon glyphicon glyphicon-log-out form-control-feedback"></span>
											<input type="submit" name="logout" value="logout" class="btn_type_text form-control">
										</div>
									</form>
								</li>
							</ul>
						</li>
                        </cfoutput>
					<cfelse>               <!---notloggedin--->
                        <cfoutput>
						<li class="dropdown login_toggle">
							<a href="" id="login_button" class="dropdown-toggle" data-toggle="dropdown" role="button" aria-haspopup="true" aria-expanded="false"><span class="glyphicon glyphicon-log-in"></span> Login</a>
							<div class="dropdown-menu">
								<form method="POST" id="login-form" style="padding: 4px;" >
									<div class="form-group">
										<label>Email:</label>
										<input type="email" name="email" required> <br/>
									</div>

									<div class="form-group">
										<label>Password:</label>
										<input type="password" name="password" autocomplete="off" required> <br/>
									</div>
                                    <div class="form-group">
									     <button type="button" class="btn btn-primary" onclick="submitform(this.form);">Login</button>
									     <input type="reset" class="btn btn-default" value="Clear" />
                                    </div>
                                    <div class="form-footer">
                                        <p>Or <a href="register.cfm"> create An acccount</a></p>
                                    </div>
								</form>

							</div>
						</li>

                        <li><a id="signup-trigger" href="register.cfm"><span class="glyphicon glyphicon-pencil"></span> Sign Up</a></li>
                        </cfoutput>
                    </cfif>
				</ul>

                <ul class="nav navbar-nav navbar-right" >
					<li class="" style="background-color: #d3d6ad;"><a href="cart.cfm" role="button" class="cart_button">
                        <span class="glyphicon glyphicon-shopping-cart"></span>  <span class="">Cart</span>
                        <span class="badge" id="badge"></span></a><!--- badge count of cart --->
                    </li>
                </ul>


            </div>
		</div>
	</nav>
