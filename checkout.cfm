<!DOCTYPE html>
<html>
<head>
    <title>Checkout</title>
    <cfinclude template="assets/libraries/libraries.cfm" />
    <link href = "assets/css/checkout.css" rel="stylesheet">
    <script src="assets/js/checkout.js"></script>
    <style>
    </style>
    <script>
    </script>
</head>
<body>

<cfinclude template="commons/header.cfm" />
<cfset checkoutCFC = createObject("cfc.checkout") />


<!--- add Address modal --->
<div id="address_modal" class="modal fade">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title text-capitalize " align="center">New Shipping address</h4>
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
                        <input type="text" class="form-control" maxlength="50" name="AddressLine" rows="3" placeholder="Contact Details.." required>
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
                        <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                        <button type="submit" class="btn btn-primary">Save &amp; Continue</button>
                </div>
            </form>
        </div>
    </div>
</div>

    <div class="container-fluid checkout_section">

        <cfset cartCFC = createObject("cfc.cart")/>
        <cfset cartIsEmpty = cartCFC.isCartEmpty()/>
        <!--- LEFT that part where status in session is checkout --->
    <cfif NOT session.loggedin>
        <h4 class="jumbotron well">Please <a href="" data-toggle="dropdown" data-target=".login_toggle">Login</a> To complete Checkout Process</h4>
    <cfelseif cartIsEmpty>
        <cfset val =( #cgi.HTTP_REFERER# EQ '' )/>
        <cfif val EQ "YES">
            <cfoutput>
                <cflocation url="index.cfm" addtoken="false" />
            </cfoutput>
        <cfelse>
            <cflocation url="#cgi.HTTP_REFERER#" addtoken="false" />
        </cfif>
    <cfelse>
        <!--- loggedin >>  show address  --->
        <cfif NOT StructKeyExists(session.User, "checkout")>
            <cfset session.User.checkout = {
                step = 0
                } />
        </cfif>

        <div id="address_section" class="section">

            <div id="address_header" class="section_header">
                <div class="header_text">Delivery Address</div>
                <div class="show_when_collapsed" style="display:none;">
                    <button type="button" class="btn btn-changeaddress" onclick="revertToStep0();">Change address</button>
                </div>
            </div>

            <cfset addresses = checkoutCFC.getAddressesOfUser() />
            <div class="subsection" style="display:none;">
            <div class="addresses">
                <cfif addresses.recordCount>    <!--- populate the address inside addres section --->
                <cfoutput>
                <cfloop query="addresses" >
                    <div class="address" style="position:relative;">
                            <h4>#Name#</h4>
                            <hr />
                            #AddressLine#   <br />
                            #PostalCode#    <br />
                            #City#  <br />
                            #State# <br />
                            <div style="position:absolute; bottom:3px;">
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
                    <button type="button">Review Order</button>
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
                subsection
            </div>
        </div>
    </cfif>
    </div>
    <!--- <cfset session.status = "finishedCheckout" /> --->
<cfinclude template="commons/footer.cfm" />
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
