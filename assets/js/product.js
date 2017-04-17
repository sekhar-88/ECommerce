$(document).ready(function(){
    var productAddFormValidator = $("form#product-add-form").validate();

    $(".product-price").hide();
    $(".product-discounted-price").hide();
    $("form#product-add-form").validate({
        messages: {
            Name: "Enter product name",
            ListPrice: "This field is required",
            Image: "Choose product Image"
        }
    });

    $(".product-discounted-price").each(function(){
        if($.trim($(this).text())  == "") {
            $(this).prev(".product-price").show().prepend("₹");
        }
        else{
            $(this).addClass("strikethrough").show().prepend("₹");
            $(this).prev(".product-price").show().prepend("₹");
        }
    });

    $(".product").click(function(){
        window.location = $(this).find("a").attr("href");
        return false;
    });

    $("#brands-filter :checkbox").change(function(){
        if(this.checked){
            $(".product").css("display","none");
            $.each( $("#brands-filter :checkbox") , function(i, item){
                if(this.checked)
                $(".product.brand_"+this.value).css("display", "flex");
            });
        }
        else{
            if($("#brands-filter :checkbox:checked").length == 0)
                $(".product").css("display", "flex");   //  show all Brands
            else $(".product.brand_"+this.value).css("display","none");  //hide that Brand
            // console.log(this.value);
        }
    });

    $("#product-add-form-submit-button").click(function(){
        if($(this).valid() ) {
            var pName = $("form#product-add-form")[0].elements.Name.value;
            console.log("checking for already existing product: " + pName);
            $.ajax({
                url: "../cfc/product.cfc?method=checkExistingProduct",
                data: {
                    name: pName
                },
                datatype: "json"
            }).done(function(response){
                console.log("response: " + response);
                if(response != "true" ){
                    console.log("product doesn't exists");
                    var desc = "";
                    // going to submit form
                    $.each( $(".product-desc-fields > input "), function(i, item){
                        desc += $(item).val() + " " ;
                        if( (i+1)%2 == 0 )
                        { desc +=  "`"}
                        else{
                            desc += " : ";
                        }
                    });
                    $("textarea#prdt-desc").val(desc);
                    // console.log($("form"));
                    $("#product-add-form").submit();
                }
                else {
                    console.log("product already exists;");
                    productAddFormValidator.showErrors({
                        Name : "this product already exists"
                    });
                }
            }).fail(function(error){
                console.log(error);
            });
        }
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

});



onload = function () {
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }
