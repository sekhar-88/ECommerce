<cfset checkoutCFC = createObject("cfc.checkout") />
<cfset cartCFC = createObject("cfc.cart")/>

<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <link href = "../assets/css/checkout.css" rel="stylesheet">
    <script src="../assets/js/checkout.js"></script>

</head>
<body>

<cfinclude template="/commons/header.cfm" />
<!--- pagerefreshlogic --->
<input type="hidden" id="refreshed" value="no"/>


<!--- add Address modal --->
<div id="address_modal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title text-capitalize " align="center"></h4>
            </div>

            <form method="POST" id="newaddress-form">

                <div class="modal-body">
                    <div class="form-group">
                        <label>Name:</label>
                        <input type="text" class="form-control" maxlength="100" name="Name" placeholder="Enter your name.." required>
                    </div>
                    <div class="form-group">
                        <label>Pincode:</label>
                        <input type="number" class="form-control" maxlength="15" name="PostalCode" min="0" required>
                    </div>
                    <div class="form-group">
                        <label>Address:</label>
                        <input type="text" class="form-control" maxlength="100" name="AddressLine" rows="3" placeholder="Contact Details.." required>
                    </div>
                    <div class="form-group">
                        <label>Phone No:</label>
                        <div class="input-group">
                            <span class="input-group-addon">+91</span>
                            <input type="number" class="form-control" name="PhoneNo" maxlength="10" min="0" data-validation-error-msg-container="#error-container" required>
                        </div>
                        <label id="PhoneNo-error" class="error" for="PhoneNo"></label>
                    </div>
                    <div class="form-group">
                        <label>Landmark:</label>
                        <input type="text" class="form-control" maxlength="20" name="LandMark">
                    </div>
                    <div class="form-group">
                        <label>Country:</label>
                        India
                        <!--- <input type="text" class="form-control" maxlength="20" name="Country" required> --->
                    </div>
                </div>
                <div class="modal-footer">
                        <button type="button" class="btn btn-danger" data-dismiss="modal">Close</button>
                        <button type="button" class="btn btn-primary modal-submit-link" onclick="">Save &amp; Continue</button>
                        <button type="reset"  class="btn btn-default">Clear</button>
                </div>
            </form>
        </div>
    </div>
</div>

<div>
        <h3 id="section-checkout-header" style="background-color: #fff59d;" class="color-grey padding-10 margin-0 margin-top--19">
            <span class="glyphicon glyphicon-shopping-cart color-black font-size-20"></span> Product checkout
        </h3>
        <p></p>
</div>
    <div class="container-fluid checkout_section">
        <cfset cartIsEmpty = cartCFC.isCartEmpty()/>

    <cfif NOT session.loggedin>
        <h4 class="jumbotron well">Please <a href="" data-toggle="dropdown" data-target=".login_toggle">Login</a> To complete Checkout Process</h4>
    <cfelseif cartIsEmpty>

        <cfset val =( #cgi.HTTP_REFERER# EQ '' )/>

        <cfif val EQ "YES">
            <cfoutput>
                <cflocation url="index.cfm" addtoken="false" />
            </cfoutput>
        <cfelse>
            <cflocation url="cart.cfm" addtoken="false" />
        </cfif>

    <cfelse>
        <!--- loggedin >>  show address  --->
        <cfif NOT StructKeyExists(session.User, "checkout")>
            <cfset session.User.checkout = { step = 0 } />
        </cfif>

        <div id="address_section" class="section">
            <div id="address_header" class="section_header">
                <div class="header_text">Delivery Address</div>
                <div class="show_when_collapsed" style="display:none;">
                    <button type="button" class="btn btn-review border-radius-2" onclick="revertToStep0();">Change address</button>
                </div>
            </div>

            <cfset addresses = checkoutCFC.getAddressesOfUser() />
            <div class="subsection" style="display:none;">
            <div class="addresses">
                <cfif addresses.recordCount>    <!--- populate the address inside addres section --->
                <cfoutput>
                <cfloop query="addresses" >
                    <div class="address" style="position:relative;" data-addressid="#AddressId#" data-name="#Name#" data-address-line="#AddressLine#" data-postal-code="#PostalCode#" data-city="#City#" data-state="#State#" data-phone-no="#PhoneNo#" data-landmark="#LandMark#">
                            <h5>#Name#</h5>
                            <span class="separator" role="separator"></span>
                            <div style="height:120px; padding: 4px;">
                            #AddressLine#   <br />
                            <span class="text-success">PIN</span>: #PostalCode#    <br />
                            <span class="text-success">Mob</span>: #PhoneNo#
                            </div>
                            <div style="">
                                <button type="button"  value="#AddressId#" class="btn btn-success btn-sm" onclick="storeAddressGotoStep1(this);">   Deliver Here  </button>
                                <button type="button"  value="#AddressId#" class="btn btn-info btn-sm" onclick="editAddress(this);">    Edit          </button>
                                <button type="button"  value="#AddressId#" class="btn btn-warning btn-sm" onclick="deleteAddress(this);">  Delete        </button>
                            </div>
                    </div>
                </cfloop>
                </cfoutput>
                <cfelse>  <!--- no addresses available for the user--->
                        <div class="no_address">
                            No Addresses.
                        </div>
                </cfif>
            </div>
            <div class="new_address"  onclick="addNewAddressShowModal();" >
                <span class=""><span class="glyphicon glyphicon-plus"></span> New Address</span>
            </div>
            </div>
        </div>


        <div id="order_summary" class="section">
            <div id="summary_header" class="section_header">
                <div class="header_text">Order Summary</div>
                <div class="show_when_collapsed" style="display:none;">
                    <button type="button" onclick="reviewOrder()" class="btn btn-review border-radius-2">Review Order</button>
                </div>
            </div>
<!---
.subsection .items
            .summary_subsection_header
                .item_name_header
                .item_qty_header
                .item_price_header
            .item
                .item_name
                .item_qty
                .item_price
--->
            <div class="subsection" style="display:none;">
                <div class="summary_subsection_header">
                    <div class="item_name_header">ITEMS</div>
                    <div class="item_qty_header">QTY</div>
                    <div class="item_price_header">PRICE</div>
                    <div class="item_remove_header">REMOVE</div>
                </div>
                <!-- Item Container goes here containing the All the products -->
                <div class="items">
                <!--
                    <div class="item">
                        <div class="item_name">
                        </div>
                        <div class="item_qty">
                        </div>
                        <div class="item_price">
                        </div>
                        <div class="item_remove_icon">
                            <span class='glyphicon glyphicon-remove' data-dismiss-id="+ item.id +"></span>
                        </div>
                    </div>
                -->
                </div>
                <div>
                    <button type="button" class="btn btn-success" onclick="if(validateItemQuantity()) { gotoPaymentSection(this);}" style="float:right;padding: 10px; font-size: 17px; font-weight: 400;box-shadow:1px 1px 5px lightgrey; border-radius: 2px; z-index: 100;">Proceed to Payment</button>
                    <div style="float:right;padding: 5px;">
                        <span style="font-weight:bold; padding: 10px;">Total:</span>
                        <span class="fa fa-inr checkoutPrice"></span> <span class="checkoutPrice" id="total-checkout-price"> </span><span class="checkoutPrice">/-</span>
                    </div>
                </div>

            </div>
        </div>


        <div id="payment_section" class="section">
            <div id="payment_header" class="section_header">
                <div class="header_text">Payment Method</div>
                <div class="show_when_collapsed" style="display:none;">
                    <button type="button">payment_review</button>
                </div>
            </div>

            <div class="subsection" style="display: none;">
                <div style="padding:10px; margin: 20px; height: 300px;position: relative;">
                    <nav style="float:left; width: 20%;">
                    <ul class="nav nav-pills nav-stacked">
                        <li class="active"><a data-toggle="pill" href="#cod-section"><i class="fa fa-inr"></i> Cash On Delivery</a></li>
                        <li><a data-toggle="pill" href="#debitcard-section"><i class="fa fa-credit-card-alt"></i> Debit Card</a></li>
                        <li><a data-toggle="pill" href="#netbanking-section" ><i class="fa fa-university"></i> Net Banking</a></li>
                    </ul>
                    </nav>

                    <div class="tab-content" style="">
                        <div id="cod-section" class="tab-pane fade in active">
                            <!--- <h6>pay using cash on delivery</h6> --->

                            <div class="payment-subsection"> <button type="button" class="btn btn-warning no-border-radius" onclick="placeOrderByCOD()"> PLACE ORDER</button> </div>
                        </div>
                        <div id="netbanking-section" class="tab-pane fade">
                            <!--- <h6>pay using net banking</h6> --->

                            <div class="payment-subsection">netbanking-section</div>
                        </div>
                        <div id="debitcard-section" class="tab-pane fade">
                            <!--- <h6>pay using Debit Card</h6> --->

                            <div class="payment-subsection">Pay Using Debit Card</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!--- <cfdump var="#session#" /> --->
    </cfif>
    </div>

<cfinclude template="/commons/footer.cfm" />
</body>
</html>


<!--- CLASS/ ID STRUCTURE

.checkout_section .container-fluid
    .section #address_section
        .subsection_header #address_header
            .header_text
            .show_when_collapsed
        .subsection
            .addresses
                .address  / .no_address
            .new_address

    .section #order_summary
        .subsection_header #summary_header
            .header_text
            .show_when_collapsed
        .subsection .items
            .summary_subsection_header
                .item_name_header
                .item_qty_header
                .item_price_header
            .item
                .item_name
                .item_qty
                .item_price

    .section #payment_section
        .subsection_header #payment_header
            .header_text
            .show_when_collapsed
        .subsection
--->
