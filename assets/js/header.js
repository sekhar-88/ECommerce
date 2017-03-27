var login_validator
$(document).ready(function(){
    login_validator = $("#login-form").validate();
});

    $(document.body).on("mouseenter", ".category", function(event) {
        $(this).children('.subcat_list_div').fadeIn(100);
    });

    $(document.body).on("mouseleave", ".category", function(event) {
        $(this).children('.subcat_list_div').hide();
    });
    $(document.body).on('click', '.category', function(e){
        e.stopPropagation();
    });
    $(document.body).on('keypress', 'form input', function(e){
        if(e.which == 13){
            submitform($("#login-form")[0]);
        }
    });

    function submitform(form){
        oform = form.elements;
        mail = oform.email.value;
        pswd = oform.password.value;
        console.log(oform);
        console.log(mail + " "+ pswd);
        if(mail.trim() == "" || pswd.trim() == ""){
            $("#login-form").submit();
        }
        else{
            $.ajax({
                url: "cfc/user.cfc?method=validate",
                data: {
                    email: form.email.value,
                    password: form.password.value
                },
                dataType: "json",
                success: function(response){
                    if(response == true){
                        // alert('login success.. will now submit the form');
                        $("#login-form").submit();
                    }
                    else{
                        login_validator.showErrors({
                            password : "invalid username/password"
                        });
                    }
                },
                error: function(error){
                    alert("check console for error");
                    console.log(error);
                }
            });

        }
    }

//update cart count pageonload bind
function updateCartCount(){
    $.ajax({
        url: "cfc/cart.cfc?method=getCartCount",
        dataType: "json"
    }).done(function(response){
        console.log(response);
        $("#badge").text(response);
    }).fail(function(error){
        console.log(error);
    });
}
// alert('header.js loaded');
