$(document).ready(function(){
    $("form#product-update-form").validate();

    $("form#product-update-form").submit(function(){
        var productDescription = "";
        $.each($(".product-desc-fields > .desc-fields > .y"), function(i, item){
            productDescription += $(item).val() + "`";
        });
        $("#prdt-desc").val(productDescription);
    });


    // file input bootstrap box in product add form - ( while in admin mode )
        $(document).on('change', ':file', function() {
            var input = $(this),
                numFiles = input.get(0).files ? input.get(0).files.length : 1,
                label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
            input.trigger('fileselect', [numFiles, label]);
        });

    // We can watch for our custom `fileselect` event like this
        $(':file').on('fileselect', function(event, numFiles, label) {

           var input = $(this).parents('.input-group').find(':text'),
               log = numFiles > 1 ? numFiles + ' files selected' : label;

           if( input.length ) {
               input.val(log);
           } else {
               if( log ) alert(log);
           }

        });

    //unbind the enter key for  forms being submitted on ENTER KEY PRESS
    $('#product-update-form').on('keyup keypress', function(e) {
        var keyCode = e.keyCode || e.which;
        if (keyCode === 13) {
            e.preventDefault();
            return false;
        }
    });

    // CHANGE PRICE FORMAT TO LOCAL FORMAT WITH COMMAS
    $(".pd-price > span:last-child").text(parseInt($(".pd-price > span:last-child").text()).toLocaleString('en-IN'));
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
        url: "../cfc/product.cfc?method=user_checkout",
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
        url: "../cfc/product.cfc?method=addToCart",
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


//for appending input boxes to update Product Modal
function appendInputBox(el){
    $(el).prev().children(".desc-fields").append("<input type='text' class='y form-control' placeholder='desc...'>");
}

function deleteProduct(pid){
    $.ajax({
        url:"../cfc/product.cfc?method=deleteProduct",
        data: {
            pid : pid
        },
        dataType: "json",
    }).done(function(response){
        if(response == "true"){
            alert("product Deleted");
            location.href = "index.cfm";
        }
        else if( response == "false") {
            alert("product is linked to some orders.. so marked as Discontinud");
            $.ajax({

            })
        }
    })
}
