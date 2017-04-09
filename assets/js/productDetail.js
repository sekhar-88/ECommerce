$(document).ready(function(){
    $("form#product-update-form").validate();
    $("form#product-update-form").submit(function(){
        var productDescription = "";
        $.each($(".product-desc-fields > .y"), function(i, item){
            productDescription += $(item).val() + "`";
        });
        $.each($(".product-desc-fields > .x"), function(i,item){
            if(i % 2 == 0){
                productDescription += $(item).val() + " ";
            }
            else{
                productDescription += $(item).val() + "`";
            }
        });
        $("#prdt-desc").val(productDescription);
    });
});

function checkOut(el,uid){
    var pid = $(el).val();
    if(uid == undefined)    //buy now button on product detail page
        alert('login to checkout');
    else{                   // buy now clicked .. not logged in
        user_checkout(pid);
    }
}

//clicked buyNow button
function checkOut(el, uid){
    var pid = $(el).val();
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
                notify("Added to cart! <a href='cart.cfm' style='color: #42a5f5; font-weight: bold;'>Goto Cart</a>", "success", "fa fa-check-circle");
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
    $(btn).html('<button type="button" value="##" onclick="window.location.href=\'cart.cfm\';" class="btn btn-lg btn-primary verdana btn-radius-1"><span class="glyphicon glyphicon"></span> Go To Cart</button>');
}

function showLoginMsg(){
    $(".login-notify").show(300);
}

function showUpdateModal(pid){
    $("#update-product-modal").modal('show');
}

function updateProductDetails(){
    $("form#product-update-form")[0].submit();
}

onload = function () {
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }
