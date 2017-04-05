// TEMPLATE function
// function notify(msg, alertType, icon, title, icontype, enter_anim, exit_anim)

var login_validator
$(document).ready(function(){
    login_validator = $("#login-form").validate();
    updateCartCount();
    $("#product-search-form").submit(function(e){
        if($("#product_searchbox").val().trim() != "" ){
            var query_cleaned = $("#product_searchbox").val().trim();
            $("#product_searchbox").val(query_cleaned);
            // fillBrands(q);
        }
        else{
            e.preventDefault();
            notify("enter some value first..", "warning");
        }
    })
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

    $(document.body).on('keypress', '#login-form input', function(e){
        if(e.which == 13){
            submitform($("#login-form")[0]);
        }
    });

    function submitform(oform){
        form = oform.elements;
        mail = form.email.value;
        pswd = form.password.value;
        console.log(mail + " "+ pswd);

        if( $("#login-form").valid() ) {

            $.ajax({
                url: "cfc/user.cfc?method=validate",
                data: {
                    email: mail,
                    password: pswd
                },
                dataType: "json",
                success: function(response){
                    if(response.status == true){
                        // alert("user successfully validated");
                        $("#login-form").submit();
                    }
                    else{
                        var error = response.errortype;
                            switch (response.errortype) {
                                case "email":
                                    login_validator.showErrors({
                                        email : "User does not exist"
                                    });
                                    break;
                                case "password":
                                    login_validator.showErrors({
                                        password : "wrong password"
                                    });
                                    break;
                                default:
                                    alert("unknown error occured while logging in");
                            }
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
        $("#badge").text(response);
    }).fail(function(error){
        console.log(error);
    });
}
// alert('header.js loaded');

function notify(msg, alertType, icon, title, icontype, enter_anim, exit_anim){

    // alert("message: " + msg + "\nalertType: " + alertType + "\nIcon: " + icon + "\nTitle: " + title + "\nIcontype: " + icontype + "\nEnterAnimation: " + enter_anim + "\nExitAnimation: " + exit_anim);

    if(msg          == undefined || msg         == "" )   var msg = "no message";
    if(alertType    == undefined || alertType   == "" )   var alertType = "success";
    if(icon         == undefined || icon        == "" )   var icon = "";
    if(title        == undefined || title       == "" )   var title="";
    if(icontype     == undefined || icontype    == "" )   var icontype = "class";
    if(enter_anim   == undefined || enter_anim  == "" )   var enter_anim = 'fadeInUp';
    if(exit_anim    == undefined || exit_anim   == "" )   var exit_anim = 'fadeOutDown';

    $.notify({
        title: title,
        message: "<span class='"+ icon +"'> " + msg + "</span>"
    },
    {
        // element: '#notify-div',
        type: 'pastel-' + alertType,
        // icon_type: icontype,
        delay: 1000,
        animate:    {
                enter: "animated " + enter_anim,
                exit: "animated " + exit_anim
        },
        placement: {
            from: "bottom",
            align: "center"
        },
        // position: "null"
        // template: '<div data-notify="container" class="col-xs-11 col-sm-3 alert alert-{0}" role="alert">' +
		//             '<span data-notify="title">{1}</span>' +
		//             '<span data-notify="message">{2}</span>' +
	    //           '</div>'
    });
}
