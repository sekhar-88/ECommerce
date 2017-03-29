function checkOut(el,uid){
    var pid = $(el).val();
    if(uid == undefined)    //buy now button on product detail page
        alert('login to checkout');
    else{                   // buy now clicked .. not logged in
        user_checkout(pid);
    }
}

//clicked buyNow button
function user_checkout(pid){
    $.ajax({
        url: "cfc/product.cfc?method=user_checkout",
        data: {
            pid: pid
        },
        dataType: "json",
        success: function(response){
            if(response == true) {
                // alert('Product is now in Cart\ngoing to address page...');
                window.location.href = "checkout.cfm";
            }
        },
        error: function(error){
            alert('error');
            console.log(error);
        }
    })
}


function addToCart(el){
    var prdtId = el.value;
    // alert(prdtId);

    $.ajax({
        url: "cfc/product.cfc?method=addToCart",
        data: {
            pid: prdtId
        },
        success: function(response){
            if(response == "true"){
                var val = $("#badge").text();
                val++;
                // alert("cart changed");
                $("#badge").text(val);
                console.log('Cart Items Changed.. Resetting Checkout Step to 0');
            }
            else{
                alert('already in cart' + response);
            }
        },
        error: function(){
            alert('Error Adding to Cart');
        }
    })
}

function changeto_gotocart(){
    var btn = $("#addtocart_btn");
    $(btn).children("button").remove();
    $(btn).html('<button type="button" value="##" onclick="window.location.href=\'cart.cfm\';" class="btn btn-sm btn-primary verdana"><span class="glyphicon glyphicon"></span> Go To Cart</button>');
}
