$().ready(function(){


});

function checkout(){
    $.ajax({
        url: "cfc/user.cfc?method=isUserLogggedin",
        dataType: "json",
        success: function(response){
            if(response == true){
                window.location.href="checkout.cfm";
            }
            else{
                alert('please login to checkout');
            }
        }
    });
}

function user_removeFromCart(pid){
    $.ajax({
        url: "cfc/cart.cfc?method=removeFromUserCart",
        data: {
            pid: pid
        },
        dataType: "json",
        success: function(response){
            if(response == true){
                var val = $("#badge").text();
                val--;
                $("#badge").text(val);
                $("#item_" + pid).remove();
                if(val == 0) {
                    $("#checkout_pane button").attr("onclick", "alert('Add some products first..')").addClass("disabled");
                }
                console.log('cart Data Changed');
            }
            else{
                alert('response is not true ' + response);
            }
        },
        error: function(){
            alert('Error Removing');
        }
    })
}

function removeFromSessionCart(pid){
    $.ajax({
        url: "cfc/cart.cfc?method=removeFromSessionCart",
        data: {
            pid: pid
        },
        success: function(response){
            if(response == "true"){
                var val = $("#badge").text();
                val--;
                $("#badge").text(val);
                $("#item_" + pid).remove();
                if(val == 0) {
                    $("#checkout_pane button").attr("onclick", "alert('Add some products first..')").addClass("disabled");
                }
                // console.log('cart Data Changed');
            }
            else{
                alert('response is not true' + response);
            }
        },
        error:function(error){
            alert(error);
        }
    });
}

function fetchCartItems(){
    $.ajax({
        url: "cfc/cart.cfc?method=getCartItems",
        dataType: "json"
    }).done(function(response){
        if(response.length) {                   //Cart not empty

            var fnOpen;
            if("CartId" in response[0]) fnOpen = "user_removeFromCart("; // in user Cart
            else                        fnOpen = "removeFromSessionCart("; //in session Cart
            var fnClose = ")";

            $.each(response, function(i, item){
                    console.log(item);
                    var itemStr = '<div id="item_'+item.ProductId+'" class="item">'
                                    +   '<div class="item_info">'
                                    +       item.ProductId + ' ' + item.Name
                                    +   '</div>'
                                    +   '<div class="item_actions">'
                                    +       '<button type="button" class="btn btn-warning" onclick="'+fnOpen+item.ProductId+fnClose+'">Remove</button>'
                                    +   '</div>'
                                + '</div> '
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