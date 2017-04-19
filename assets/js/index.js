//signature: filterDisplayRemove(display/remove,  subcategory_class, Brand_class, Price_class)

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


    $("#category-checkbox :checkbox").change(function(){
        if(this.checked){
            $(".product").css("display", "none");

            $.each( $("#category-checkbox :checkbox"), function(i, item){
                if(this.checked)    filterDisplayRemove("display",  ".product.scat_"+this.value , "", "");   //signature: filterDisplayRemove(display/remove,  subcategory_class, Brand_class, Price_class)
            });
            // //console.log(this.value);
        }
        else{
            if($("#category-checkbox :checkbox:checked").length == 0)
                $(".product").css("display", "block");    // show all
            else filterDisplayRemove("remove", ".product.scat_"+this.value, "", "")
        }
    });
});

function showProduct(string){

}


function filterDisplayRemove(displayremoveaction, subcategoryclass, brandclass, priceclass ){
    if(subcategoryclass != "")
        if(displayremoveaction == "display")        $(subcategoryclass).css("display","block");   //show those filters
        else if(displayremoveaction == "remove")    $(subcategoryclass).css("display","none");  //hide that (sub)category

    // if(brandclass != "")
    //
    //     else
}


onload = function () {
                   var e = document.getElementById("refreshed");
                   if (e.value == "no") e.value = "yes";
                   else { e.value = "no"; location.reload(); }
               }
