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


    $("#product-add-form-submit-button").click(function(){
        if($(this).valid() ) {
            var pName = $("form#product-add-form")[0].elements.Name.value;
            //console.log("checking for already existing product: " + pName);
            $.ajax({
                url: "../cfc/product.cfc?method=checkExistingProduct",
                data: {
                    name: pName
                },
                datatype: "json"
            }).done(function(response){
                //console.log("response: " + response);
                if(response != "true" ){
                    //console.log("product doesn't exists");
                    var desc = "";
                    // going to submit form
                    $.each( $(".product-desc-fields > input "), function(i, item){
                        desc += $(item).val() + " " ;
                        if( (i+1)%2 == 0 ){
                            desc +=  "`";
                        }
                        else{
                            desc += " : ";
                        }
                    });
                    $("textarea#prdt-desc").val(desc);
                    // //console.log($("form"));
                    $("#product-add-form").submit();
                }
                else {
                    //console.log("product already exists;");
                    productAddFormValidator.showErrors({
                        Name : "this product already exists"
                    });
                }
            }).fail(function(error){
                //console.log(error);
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


    // brand filters change
    $("#brands-filter :checkbox").change(function(){

        if(this.checked){   //check action
            $(".products-inner").empty();

            $.each( $("#brands-filter :checked") , function(i, item){
                var brandid = this.value;
                var scat = $(this).data('scat');

                $.ajax({
                    url: "../cfc/product.cfc?method=getFilteredProducts",
                    data: {
                        brandid : brandid,
                        scat : scat
                    },
                    dataType : "json"
                }).done(function(response){
                    //console.log(response.STATUS);
                    if(response.STATUS == "success") {
                        var productsArray = response.RESULT;
                        //console.log(productsArray);
                        showInProductsList(productsArray);
                    }
                }).fail();
            })
        }
        else{               //uncheck action

            if($("#brands-filter :checkbox:checked").length == 0) {
                var scat = $(this).data('scat');
                $.ajax({
                    url: "../cfc/product.cfc?method=getFilteredProducts",
                    data: {
                        scat : scat
                    },
                    dataType : "json"
                }).done(function(response){
                    //console.log(response.STATUS);
                    if(response.STATUS == "success") {
                        var productsArray = response.RESULT;
                        //console.log(productsArray);
                        showInProductsList(productsArray);
                    }
                }).fail();
            }

            else {
                    $(".products-inner").empty();
                    $.each( $("#brands-filter :checked") , function(i, item){
                        var brandid = this.value;
                        var scat = $(this).data('scat');

                        $.ajax({
                            url: "../cfc/product.cfc?method=getFilteredProducts",
                            data: {
                                brandid : brandid,
                                scat : scat
                            },
                            dataType : "json"
                        }).done(function(response){
                            //console.log(response.STATUS);
                            if(response.STATUS == "success") {
                                var productsArray = response.RESULT;
                                //console.log(productsArray);
                                showInProductsList(productsArray);
                            }
                        }).fail();
                    });
            }
        }
    });
});

function showInProductsList(productsArray){
    $.each(productsArray, function(i, productObj){
        //console.log(productObj);

        var link = '<a href="productDetails.cfm?pid='+productObj.ProductId+'"></a>' ;
        var image = '<div class="product-image">' +
                    '<img class="" src="../assets/images/products/medium/'+productObj.Image+'">' +
                    '</div>' ;

                var name = '<div class="product-name"> '+productObj.Name+' </div>';
                var pricing = '<div class="product-pricing">' +
                              '<div class="product-price"> '+ productObj.ListPrice +'  </div>' +
                              '<div class="product-discounted-price">'+productObj.DiscountPercent+'</div>' +
                              '</div>' ;

                              var descArr = productObj.Description.split("`");

                              var descStr = "";

                              $.each(descArr, function(i, value){
                                  descStr += '<li>'+value+'</li>';
                              });

                var desc = '<ul>'+
                            descStr +
                            '</ul>'
        var content = '<div class="product-content">' + name + pricing + desc +  '</div>'

        var product = link + image + content;

        $(".products-inner").append("<div class='product' style='display: none;'>" + product + "</div>");
        $(".products-inner .product").fadeIn();

        // bind click event to the product div
        $(".product").click(function(){
            window.location = $(this).find("a").attr("href");
            return false;
        });
    });
}

onload = function () {
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }
