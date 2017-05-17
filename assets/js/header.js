// TEMPLATE function
// function notify(msg, alertType, icon, title, icontype, enter_anim, exit_anim)

var login_validator;
$(document).ready(function(){
    // expand search box on focus & contract on blur
    $("input#product_searchbox").focus(function(){ $(this).animate({width: "400px"}); });
    $("input#product_searchbox").blur(function(){ $(this).animate({width: "100%"}); });

    // validator variable (global)
    login_validator = $("#login-form").validate({
        messages: {
            email: "Enter your email",
            password: "Enter a valid password"
        }
    });
    updateCartCount();

    $(".subcategory_list_li").click(function(){
        window.location = $(this).find("a").attr("href");
        return false;
    });

    $("#product-search-form").submit(function(e){
        if($("#product_searchbox").val().trim() != "" ){
            var query_cleaned = $("#product_searchbox").val().trim();
            $("#product_searchbox").val(query_cleaned);
            // fillBrands(q);
        }
        else{
            e.preventDefault();
        }
    });
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
        //console.log(mail + " "+ pswd);

        if( $("#login-form").valid() ) {

            $.ajax({
                url: "../cfc/user.cfc?method=validate",
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
                                        password : "invalid password"
                                    });
                                    break;
                                default:
                                    alert("unknown error occured while logging in");
                            }
                    }
                },
                error: function(error){
                    alert("check console for error");
                    //console.log(error);
                }
            });
        }

    }

//update cart count pageonload bind
function updateCartCount(){
    $.ajax({
        url: "../cfc/cart.cfc?method=getCartCount",
        dataType: "json"
    }).done(function(response){
        $("#badge").text(response);
    }).fail(function(error){
        //console.log(error);
    });
}
// alert('header.js loaded');







// globally used functions

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
        delay: 2000,
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



/*  REUSABLE

    # the code for this modal is present in the footer.cfm file of the site in commons folder
    this function shows a modal box for updating something for sometime  & then dissapears..
    accepts arguments
        message - to show in modal header ,
        delay   - time delay to show modal,
        icon    - icon to show in the body,
        callback - a function to execute after the modal disappears..
                        if not given it just reloads the page
*/
function showUpdateModal(message, delay, icon, callback) {
    $("#refresh-modal .modal-body .update-message").text(message);
    if(icon != undefined )
        $("#refresh-modal .modal-body .icon").addClass(icon);
    else
        $("#refresh-modal .modal-body .icon").addClass("fa fa-refresh fa-spin fa-2x fa-fw");

    $("#refresh-modal").modal('show');

    setTimeout(function() {
        $("#refresh-modal").modal('hide');

            if(callback == undefined)
                window.location.reload(); //just reload the page
            else callback(); //do the task - call the callback functions ( no arguments available )
    }, delay);
}

var gotoIndexPage = function(){
    window.location.href = "index.cfm";
}
