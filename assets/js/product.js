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
});
