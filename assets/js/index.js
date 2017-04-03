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
            $(".product").css("display", "none");
            $.each( $("#category-checkbox :checkbox"), function(i, item){
                if(this.checked)
                $(".product.scat_"+this.value).css("display","block");
            });

            // console.log(this.value);
        }
        else{
            if($("#category-checkbox :checkbox:checked").length == 0)
                $(".product").css("display", "block");   //  show all
            else $(".product.scat_"+this.value).css("display","none");  //hide that (sub)category
            // console.log(this.value);
        }
    });
});

function showProduct(string){

}
