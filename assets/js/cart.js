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
