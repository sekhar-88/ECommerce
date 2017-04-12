var signup_validator;
$().ready(function(){// password meter codes

    signup_validator = $("#signup_form").validate();
    var strength = {
        0: "Worst",
        1: "Bad",
        2: "Weak",
        3: "Good",
        4: "Strong"
    };
    var password = document.getElementById("pswd");
    var meter = document.getElementById("password-strength-meter");
    var text = document.getElementById("password-strength-text");

    password.addEventListener('input', function() {
        var val = password.value;
        var result = zxcvbn(val);

        // Update the password strength meter
        console.log(result.feedback.suggestions);
        meter.value = result.score;

        // Update the text indicator
        if (val !== "") {
            text.innerHTML = "Strength: " + strength[result.score];
        } else {
            text.innerHTML = "";
        }
    });


    // validate function options setting
    $("#signup_form").validate({
        rules:{
            FirstName: "required",
            Email: "required",
            Password: {
                required: true,
                minlength: 8,
            }
        },
        messages:{
            FirstName: "Please Enter your firstname",
            Email: "Provide a valid Email",
            Password: {
                required: "Please Provide a password",
                minlength: "give atleast 8 chars"
            }
        }
    });

    $("#signup_form").submit(function(e){

        var formElements = $(this)[0].elements ;
        var registrationForm = {
            "FirstName" : formElements.FirstName.value,
            "LastName" : formElements.LastName.value,
            "Email" : formElements.Email.value,
            "PhoneNo" : formElements.PhoneNo.value,
            "Password" : formElements.Password.value
        };
        console.log(registrationForm);

        if( $(this).valid() ){
            $.ajax({
                url: "../cfc/user.cfc?method=newUser",
                dataType: "json",
                contentType: "json",
                data: {
                    formSerialized : JSON.stringify(registrationForm)
                }
            }).done(function(response){
                console.log(response.STATUS);
                if(response.STATUS == true ){
                    notify("Account Created Successfully", "success", "fa fa-check-circle");
                    $("#signup-content").empty();

                    $("#signup-content").append("<div style='height: 500px;'><h1 align='center' style='color:blue;'>Account Created Successfully.</h1>\
                                                 <h2><a href='index.cfm'>go to homepage</a></h2></div>");
                }
                else {
                    console.log(response.ERROR);
                    $.each( response.ERROR , function(key, value){
                        signup_validator.showErrors({
                            Email : value
                        });

                    })
                }
            }).fail(function(error){
                console.log(error);
            });
        }

        e.preventDefault();
    });


});

// function submitRegistrationForm(oform){
//     $(oform).submit();
//     // var form = oform.elements;
//     // if( $("#signup_form").valid() ) {
//     //     $.ajax({
//     //         url: "",
//     //         data: {
//     //
//     //         }
//     //     }).done(function(response){
//     //
//     //     }).fail(function(error){
//     //         alert("registration request couldn't be processed. check log");
//     //         console.log("error")
//     //     });
//     // }
//     // $("#signup_form").validate();
// }
