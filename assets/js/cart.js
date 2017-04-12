var orderSummary;

$().ready(function(){
    // here updateCartTotalvalue is a CALLBACK function
    getCartTotal(updateCartTotalvalue);
});


var updateCartTotalvalue = function(price){
    $("#total-checkout-price").text(price);
}

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


function checkout(){
    $.ajax({
        url: "../cfc/user.cfc?method=isUserLogggedin",
        dataType: "json",
        success: function(response){
            if(response == true){
                window.location.href="checkout.cfm";
            }
            else{
                // alert("error occured");
                notify("Please Login to continue Checkout", "info", "fa fa-exclamation-circle");
            }
        }
    });
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
        if(response == true){
            var val = $("#badge").text();
            val--;
            $("#badge").text(val);
            $(el).remove();
            if(val == 0) {
                $("#checkout_pane button").attr("onclick", "alert('Add some products first..')").addClass("disabled");
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
                //    fetchCartItems();
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }




function fetchCartItems(){
    $.ajax({
        url: "../cfc/cart.cfc?method=getCartItems",
        dataType: "json"
    }).done(function(response){
        if(response.length) {                   //Cart not empty

            var fnOpen;
            if("CartId" in response[0]) fnOpen = "user_removeFromCart(this,"; // in user Cart
            else                        fnOpen = "removeFromSessionCart(this,"; //in session Cart
            var fnClose = ")";

            $.each(response, function(i, item){
                    console.log(item);
                    var itemStr = '<div id="item_'+item.ProductId+'" class="item">' +
                                    '<div class="item_info">' +
                                        item.ProductId + ' ' + item.Name +
                                    '</div>' +
                                    '<div class="item_actions">' +
                                        '<button type="button" class="btn btn-warning" data-name="'+item.Name+'" onclick="'+fnOpen+item.ProductId+fnClose+'">Remove</button>' +   // onclick="removeItemFromCart('+ item.ProductId +')">Remove</button>' +   // try this
                                    '</div>'+
                                  '</div> '
                    $("#items_pane").append(itemStr);
            });

        }
        else {
            $("#items_pane").append("<div class='item'>Currently No items in the cart</div>");
        }
    }).fail(function(error){
        console.log("error: \n");
        console.log(error);
    });
}
