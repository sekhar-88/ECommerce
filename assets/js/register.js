$().ready(function(){// password meter codes
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
});

function submitRegistrationForm(oform){
    $(oform).submit();
    // var form = oform.elements;
    // if( $("#signup_form").valid() ) {
    //     $.ajax({
    //         url: "",
    //         data: {
    //
    //         }
    //     }).done(function(response){
    //
    //     }).fail(function(error){
    //         alert("registration request couldn't be processed. check log");
    //         console.log("error")
    //     });
    // }
    // $("#signup_form").validate();
}
