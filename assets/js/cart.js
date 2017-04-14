var orderSummary;

$().ready(function(){
    // here updateCartTotalvalue is a CALLBACK function
    getCartTotal(updateCartTotalvalue);
});



function getCartTotal(callback){
    var totalCartValue = 0;
    $.ajax({
        url: "../cfc/cart.cfc?method=getCartTotal",
        dataType: "json",
        success: function(response){
            if( callback != undefined )           callback(response);
            else alert("callback undefined.. for getCartTotal function");
        }
    }).fail(function(error){
            alert(error);
    });
    return totalCartValue;
}


var updateCartTotalvalue = function(price){
    $("#total-checkout-price").text(parseInt(price).toLocaleString('en-IN'));
}

function checkout(){
    window.location.href="checkout.cfm";
}

function removeFromCart(remove_button){
    var el = $(remove_button).parent().parent();
    var pid = $(el).data('product-id');

    console.log(el);
    console.log(pid);

    $.ajax({
        url: "../cfc/cart.cfc?method=removeFromCart",
        data : {
            pid: pid
        }
    }).done(function(response){
        if(response == "true"){
            var val = $("#badge").text();
            val--;
            $("#badge").text(val);
            $(el).remove();
            getCartTotal(updateCartTotalvalue);
            if(val == 0) {
                $("#order_summary .subsection").remove();
                $(".section").append("<div class='no-items'></div>");
                $("#checkout_pane").empty();
            }
            notify("<span style='color: #42a5f5; font-weight: bold;'>" + $(el).data('name') + "</span> \rremoved from cart", "info", 'fa fa-check-circle', "", "", "fadeInUp", "fadeOutDown");
            console.log('cart Data Changed');
        }
        else{
            alert('response is not true ');
            console.log(response);
        }
    });
}


function validateItemCount(element, value, max, cartId){
    $(element).tooltip('hide');
    var pid = $(element).data('item_id');

    if(parseInt(value) > parseInt(max) || parseInt(value) < 0 || value == '' ){
        $(element).tooltip('show');
        element.value = 1;
        element.value.replace(1);
    }

    $.ajax({
        // async: false,
        url: "../cfc/cart.cfc?method=updateCartAndTotalPrice",
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

onload = function () {
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }
