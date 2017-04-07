var addressid = undefined;
var orderSummary = "";
var amountPayble = 0;

$(document).ready(function(){
    $(".show_when_collapsed").hide();
    gotoCheckOutStep();
    $("#newaddress-form").validate({
        rules:{
            Name: "required",
            PostalCode: {
                    required: true,
                    minlength: "6",
                    maxlength: "6"
            },
            AddressLine: "required",
            PhoneNo : {
                required: true,
                minlength: "10"
            },
            Country: "required"
        },
        messages:{
            Name:  "Enter The name Belonging to the address",
            PostalCode: {
                    required: "Enter a valid Postal code",
                    maxlength: "enter 6 digits"
            },
            AddressLine: "Enter The Contact Details",
            // LandMark: ""
            Country: "Enter the country",
            PhoneNo: {
                required: "Enter The Phone no. to receive updates",
            }
        }
    });
});

function gotoCheckOutStep(){
    $.ajax({
        url: "cfc/checkout.cfc?method=getCheckOutStep",
        success: function(response){
            // alert( "AT STEP: " + response)
            gotoStep(response);
        },
        error: function(error){
            alert("error: " + error);
            console.log(error);
        }
    });
}

function gotoStep(ajaxResponse){
    switch (ajaxResponse) {
        case "0":
            gotoStep0();
            // alert('did step 0');
            break;
        case "1":
            gotoStep1();
            // alert('did step 1');
            break;
        case "2":
            gotoStep2();
            alert('did step 2');
            break;
        case "3":
            gotoStep3();
            alert('did step 3');
            break;
        default:
            alert("step is not specified Correctly " + ajaxResponse);
    }
}

function gotoStep0(){
    $("#address_section .subsection").show();
}
function revertToStep0(){
    $("#order_summary .subsection,#payment_section .subsection, #address_section .show_when_collapsed, #order_summary .show_when_collapsed").hide();
    $("#address_section .subsection").slideDown(200);
    orderSummary = "";
    revertToStep(0);
}

function gotoStep1(){  //hide delivery address pane & show review order pane
    $("#order_summary .subsection").show();  //animation 300 delay
    $("#address_section .show_when_collapsed").fadeIn();
    $.ajax({
        async: false,
        url: "cfc/checkout.cfc?method=getOrderSummary",
        dataType: "json",
        success: function(response){
            console.log(response);       // response.itemsArray   // response.totalPrice
            $("#order_summary .items").empty();  //empty the previously populated items in ORDER SUMMARY

            $.each(response.itemsArray, function(index, item){
                // console.log(item);
                    var name = item.name;
                    var desc = "description";     //item.description

                    var itemDescContent = "<div>"
                                            + "<div class='cart_product_image'>"
                                            + "<img class='cart_thumbnail' src='assets/images/products/medium/"+ item.image +"' />"
                                            + "</div>"
                                            + "<h4>" + name + "</h4>"
                                            + desc
                                        + "</div>" ;

                    var itemPriceContent = "&#8377; " + item.price;

                    var itemDesc = "<div class='itemInfo'>"
                                    + itemDescContent
                                    + "</div>";
                    var itemPrice = "<div class='itemPrice'><div>"
                                    + itemPriceContent
                                    + "</div></div>";
                    var removeContent = "<div class='item_remove_icon'>"
                                        + "<span class='glyphicon glyphicon-remove' onclick='removeItem(this);' data-dismiss_id="
                                        + item.id
                                        + "></span></div>" ;

                    $.ajax({
                        async: false,
                        url: "cfc/checkout.cfc?method=getAvailableQuantity",
                        data: { itemid: item.id },
                        dataType: "json",

                        success: function(maxQty){
                            console.log("Available Products: " + maxQty);

                            //store (Product Id, prev_item_count)    in custom (Data-* attributes)  & inputItemsQuantity class is required to validate item quantity count while placing order
                            var itemQtyContent = "<span><span class='inputItemsQuantityleft'>Qty:</span><input type='number' data-toggle='tooltip' title='Max Quantity Exceeded' data-card_id='"+item.cartId+"' data-item_id="+ item.id +" + data-item_price='"+item.price+"' name='itemQty' value='"+item.qty+"' min='1' max='"+maxQty+"' class='inputItemsQuantity' onkeyup='validateItemCount(this, this.value, this.max, "+item.cartId+");' onmouseup='validateItemCount(this, this.value, this.max, "+item.cartId+")'></span>";
                            var itemQty = "<div class='itemQty'>" +   itemQtyContent + "</div>";


                            //data-session_index is for removing the corresponding entry from sessoin user Arry(session.User.checkout.itemsInfo(type array) ) while removed from checkout Page
                            $("#order_summary .items").append("<div class='item' data-session_index="+ index +" id="+ item.id +">" + itemDesc + itemQty + itemPrice + removeContent + "</div>");

                            orderSummary +=  "<div class='item' data-session_index="+ index +" id="+ item.id +">" + itemDesc + itemPrice + "/item" + "</div>"; //store in global variable
                        },

                        error: function(error){
                            notify("Error Availabing Product Quantity", "danger", "glyphicon glyphicon-info-sign");
                            console.log(error);
                        }

                    });

                    var x = (response.totalPrice).toLocaleString('en-IN')
                    $("#total-checkout-price").text(x);
                    amountPayble = x;
            });
        },

        error: function(error){
            alert("error retrieving Cart checkout Details " + error);
        }

    });
}

function validateItemCount(element, value, max, cartId){
    $(element).tooltip('hide');
    var pid = $(element).data('item_id');

    if(parseInt(value) > parseInt(max)){
        $(element).tooltip('show');
        element.value = max;
    }

    $.ajax({
        async: false,
        url: "cfc/checkout.cfc?method=updateCartAndTotalPrice",
        data: {
            cartid: cartId,
            pid: pid,
            qty: element.value
        },
        success:function(cartTotal){
            console.log(cartTotal);
            var x = parseInt(cartTotal).toLocaleString('en-IN');
            $("#total-checkout-price").text(x);
            amountPayble = x;
        },
        error: function(error){

        }
    });
}

function removeItem(element){
    var pid  = $(element).data("dismiss_id");
    var itemToBeRemovedFromCheckoutPage = $("#"+pid);  //reference to the item div
    var removeItemFromSessionUserCheckoutItemsInfoArray = $(element).parents(".item").data('session_index');
    var sessionArrayIndex = removeItemFromSessionUserCheckoutItemsInfoArray+1;

    $(itemToBeRemovedFromCheckoutPage).remove();  //remove from the checkout page
    //remove from cart too
    $.ajax({
        url:"cfc/cart.cfc?method=removeFromUserCart",
        data: {
            pid: pid
        },
        success: function(resopnse){
            var val = $("#badge").text();
            val--;
            $("#badge").text(val);
            if(val== 0){
                alert('no item in cart..\nredirecting to cart page');
                window.location.href = "cart.cfm";
            }
        },
        error:function(error){
            alert('error while removing from cart');
        }
    });

    //remove item from session too
    $.ajax({
        url: "cfc/checkout.cfc?method=refreshSessionCheckoutList",
        data: { arrayindex: sessionArrayIndex },
        dataType: "json",
        success: function(response){
            if(response == true) alert('session refreshed');
            else {  alert("error while refreshing session checkout list");
                    console.log(response);
                 }
        },
        error: function(error){
            console.log(error);
        }
    })
}

function revertToStep1(){
    revertToStep(1);
}

function gotoStep2(){
    $("#payment_section .subsection").show(300);
    $("#order_summary .show_when_collapsed").fadeIn();
}
// function revertToStep2(){
//     revertToStep(2);
// }

function revertToStep(stp){
    $.ajax({
        url: "cfc/checkout.cfc?method=revertToStep",
        data: {
            step: stp
        },
        dataType: "json",
        success: function(response){
            // alert(response);
        },
        error: function(error){
            alert(error);
        }
    });
}



function storeAddressGotoStep1(el){  //gotoOrderSummary Section
    addressid = $(el).val();

    $.ajax({
        url: "cfc/checkout.cfc?method=setCheckoutAddress",
        data:{
            addressid : addressid
        },
        dataType: "json",
        success: function(response){
            // alert(response);
        },
        error: function(error){

        }
    });
    // alert(addressid);
    $(el).parents(".subsection").slideUp(300);
    gotoStep1();
}

function gotoPaymentSection(el){
    $("#order_summary .subsection").slideUp(300);  //this is only here because it is not needed when page refreshed
    gotoStep2();                             //others are in this function

}
function reviewOrder(el){
    $("#payment_section .subsection, #order_summary .show_when_collapsed").hide();
    $("#order_summary .subsection").show(); // animation 300
    // revertToStep(1);
}

function addNewAddressShowModal(){
    document.getElementById("newaddress-form").reset();
    $(".modal-title").text("New Shipping Address");
    $(".modal-submit-link").attr("onclick", "addAddress(this.form)");
    $("#address_modal").modal('show');
}

function addAddress(form){
    if($("#newaddress-form").valid())
    {
        alert("going to submit ");
        addNewAddress(form);
    }
}

function addNewAddress(oform){
    var form = oform.elements;
    $.ajax({
        url: "cfc/checkout.cfc?method=saveShippingAddress",
        data:
        {
            AddressLine: form.AddressLine.value,
            Name: form.Name.value,
            LandMark: form.LandMark.value,
            PhoneNo: form.PhoneNo.value,
            PostalCode: form.PostalCode.value
        },
        dataType: "json"
    }).done(function(response){
        console.log(response);
        window.location.reload(false);
    }).fail(function(error){
        console.log("Error");
        console.log(error);
    });
}

function deleteAddress(dltBtn){
    if( confirm("Sure to Delete the Address?") == true ){
        $.ajax({
            url: "cfc/checkout.cfc?method=deleteAddress&addressid="+dltBtn.value,
            dataType: "json"
        }).done(function(response){
            console.log(response + " removed Address");
            $(dltBtn).parents(".address").remove();
        }).fail(function(error){
            console.log(error);
        });
    }
    else {
    }
}

function editAddress(editBtn){
    var addressDiv = $(editBtn).parents(".address");

    $("#newaddress-form input[name='Name']").val(addressDiv.data('name'));
    $("input[name='PostalCode']").val(addressDiv.data('postal-code'));
    $("input[name='AddressLine']").val(addressDiv.data('address-line'));
    $("input[name='PhoneNo']").val(addressDiv.data('phone-no'));
    $("input[name='LandMark']").val(addressDiv.data('landmark'));

    $(".modal-title").text("Edit Address");
    $(".modal-submit-link").attr("onclick", "editAddressAndSave(this.form,"+addressDiv.data('addressid')+")");
    $("#address_modal").modal('show');
}

function editAddressAndSave(form,address_id){
    // alert('clicked' + address_id);

    $.ajax({
        url: "cfc/checkout.cfc?method=updateShippingAddress",
        data: {
            addressid : address_id,
            formdata : $(form).serialize()
        },
        success: function(response){
            console.log(response);
            window.location.reload();
        },
        error: function(error){
            console.log(error);
        }
    })
    console.log(form);

}


function placeOrderByCOD(){
    if(validateItemQuantity()){  //purchasee section handling
        $.ajax({
            url: "cfc/checkout.cfc?method=orderPlacedByCOD",
            data:{},
            dataType: "json",
            success: function(response){
                if(response.status){
                    alert("added to Orders & Orderdetails");
                    $("#section-checkout-header").remove();
                    // $("p").eq(0).css("height","45px");
                    str = '<div><h1 align="center" style="color: blue;"><span></span>Thank you for your order!</h1>'
                            +'<span style="color: #4CAF50;">Your order has been placed and is being processed. When the item(s) are shipped, you will receive an email with the details.</span></div>'
                            +'<div><h2 align="center" style="color: teal;font-weight: bold;">Amount Payble:'+amountPayble+'</h2></div>'
                    $(".checkout_section").html(str + orderSummary);
                    // set step  = 0
                    // cart datachanged = true
                    // cart 0
                    $("#badge").text(0);
                }
            },
            error: function(error){
                alert("error while processing COD request.");
                console.log(error);
            }
        });
    }
    else{ //item quantity is not valid
        alert("item quantity is not valid");
    }
}

function validateItemQuantity(){
    var result;
    var productCountvalid = true;

    $.each($(".inputItemsQuantity"), function(i, element){
        var qty = element.value;
        var itemId = $(element).data('item_id');

        console.log(qty + itemId);
        if( parseInt(qty) > 0 ){
            $.ajax({
                    async: false,
                    url: "cfc/checkout.cfc?method=getAvailableQuantity",
                    data: {
                        itemid: itemId
                    },
                    dataType: "json",
                    success: function(maxQty){
                        if( qty > maxQty ) {
                            console.log('item quntity manipulated/not authentic');
                            result = false;
                        }
                        else result = true;
                    },
                    error: function(error){ alert('Error retrieving Available Product Quantity'); }
            });
        }
        else{
            productCountvalid = false;
            result = false;
            return false;  // equivalent to break;
        }
    });
    if(!productCountvalid) notify("Invalid product quantity", "info", "fa fa-exclamation-circle");
    return result;
}

onload = function () {
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }
