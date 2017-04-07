$(document).ready(function(){
    $(".product_price").hide();
    $(".product_discounted_price").hide();

    $(".product_discounted_price").each(function(){
        if($.trim($(this).text())  == "") {
            $(this).prev(".product_price").show().prepend("₹");
        }
        else{
            $(this).addClass("strikethrough").show().prepend("₹");
            $(this).prev(".product_price").show().prepend("₹");
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

    $("form#product_add_form").submit(function(e){
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
    });

});



onload = function () {
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }
