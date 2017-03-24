var addressid = undefined;

$(document).ready(function(){
    $(".show_when_collapsed").hide();
    gotoCheckOutStep();

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
    $("#order_summary .subsection, #address_section .show_when_collapsed").hide();
    $("#address_section .subsection").show(300);
    revertToStep(0);
}


function gotoStep1(){  //hide delivery address pane & show review order pane
    $("#order_summary .subsection").show(300);
    $("#address_section .show_when_collapsed").fadeIn();
    $.ajax({
        async: false,
        url: "cfc/checkout.cfc?method=getOrderSummary",
        dataType: "json",
        success: function(response){
            $("#order_summary .items").empty();  //empty the previously populated items in ORDER SUMMARY

            $.each(response, function(index, item){
                console.log(item);
                    var name = item.name;
                    var desc = "description";

                    var itemDescContent = "<div>"
                                            + "<div class='cart_product_image'>"
                                            + "<img class='cart_thumbnail' src='assets/images/products/medium/"+ item.id +".jpeg' />"
                                            + "</div>"
                                            + "<h4>" + name + "</h4>"
                                            + desc
                                        + "</div>" ;
                    var itemQtyContent = "<input data-toggle='tooltip' title='Max Quantity Exceeded' data-prev_val='1' data-item_id="+ item.id +" + type='number' name='itemQty' value='1' min='1' onkeyup='validateItemQuantity(this);' onmouseup='validateItemQuantity(this)'>";  //store (Product Id, prev_item_count) in custom (Data-* attributes)
                    var itemPriceContent = "&#8377; " + item.price;

                    var itemDesc = "<div class='itemInfo'>"
                                    + itemDescContent
                                    + "</div>";
                    var itemQty = "<div class='itemQty'>"
                                    +   itemQtyContent
                                    + "</div>";
                    var itemPrice = "<div class='itemPrice'>"
                                    + itemPriceContent
                                    + "</div>";
                    var removeContent = "<div class='item_remove_icon'>"
                                        + "<span class='glyphicon glyphicon-remove' onclick='removeItem(this);' data-dismiss_id="
                                        + item.id
                                        + "></span></div>" ;

                    $("#order_summary .items").append("<div class='item' data-session_index="+ index +" id="+ item.id +">" + itemDesc + itemQty + itemPrice + removeContent + "</div>");   //data-session_index is for removing the corresponding entry from sessoin user Arry(session.User.checkout.itemsInfo(type array) ) while removed from checkout Page
            });
        },
        error: function(error){
            alert("error retrieving Cart checkout Details " + error);
        }
    });
}

function validateItemQuantity(element){
    $(element).tooltip("hide");
    var prev_val = $(element).data('prev_val');
    var cur_val = $(element).val();
    var item_id = $(element).data('item_id');  //  .data() for retrieving Value of Custom HTML5 (Data-* Attributes)

    if(prev_val != cur_val){
        // alert('validate with the database');
        $(element).prop("readonly", true).delay(1500).prop("readonly", false);
        $.ajax({
            async: false,
            url: "cfc/checkout.cfc?method=getAvailableQuantity",
            data: {
                itemid: item_id
            },
            dataType: "json",
            success: function(maxQty){
                console.log("Available Products: " + maxQty);
                if( cur_val > maxQty ){
                    $(element).val(maxQty-1);
                    $(element).tooltip("show");
                }
            },
            error: function(error){
                alert('Error retrieving Available Product Quantity');
            }
        });
    }
    $(element).data("prev_val", "" + cur_val);
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











function storeAddressGotoStep1(el){
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
    $(el).parents(".subsection").hide();
    gotoStep1();
}

function addNewAddressShowModal(){
    $("#address_modal").modal('show');
}


function myfun(){
    console.log('thisss');
    //DELETE Payment details from Session from here == Checkout Step 2

}
window.onunload = function(){
  myfun();
  return 'Are you sure you want to leave?';
};
