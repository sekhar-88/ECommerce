$(document).ready(function(){
    // $("li.subcategory_list_li a").click(function(e){
    //
    //     e.preventDefault();
    //     var queryStr = this.href.substring(this.href.indexOf("?")+1);
    //
    //     $.ajax({
    //         method: "GET",
    //         url: "components/products.cfc?method=productList",
    //         // data: queryStr,
    //         success: function(data){
    //             // $("#content").html("<p><cf   output>#url.cat#, #url.scat#</cfoutput></p>")
    //             alert(queryStr);
    //             $("#content").html(data);
    //         },
    //         error: function(){
    //             $("#content").html("<p>error</p>");
    //             alert(url);
    //         }
    //     });
    // });

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
            console.log(this);
            alert(this);
        }
        else{
            console.log(this);
            alert(this);
        }
    });
});

function showProduct(string){

}
