$(document).ready(function(){
    $(document.body).on('keydown', '#product_action_add_button', function(e){
        populateBrandsSuppliers("brands_select_list","suppliers_select_list");
        getSubCategoryId();
    });
    $("#product_add_form").validate();
    $("#subcategory_textbox").prop('disabled', true);
});

function addProductToDB(oform){
    var form = oform.elements;
    if(form.Image.files.length != 0) { formImage = form.Image.files["0"].name; }
    else { formImage = ""; }

    var formProduct= {
        "Name" : form.Name.value,
        "BrandId" : form.BrandId.value,
        "SupplierId" : form.SupplierId.value,
        "SubCategoryId" : form.SubCategoryId.value,
        "Description" : form.Description.value,
        "ListPrice" : form.ListPrice.value,
        "Image": formImage
    }

    $.ajax({
        url: "cfc/admin.cfc?method=addNewProduct",
        data: {
            formdata : JSON.stringify(formProduct)
        },
        dataType: "json",
        success: function(response){
            console.log(response);
        },
        error: function(error){
            console.log(error);
        }
    });
}

function getSubCategoryId(){
    var subcategoryid = $("#subcategory_selectlist").val();
    $("#subCategoryValue").val(subcategoryid);
}


function fillSubCategory(name){
    $(".action_li").show();
    $.ajax({
        url: "cfc/header.cfc?method=getSubCategoriesJSObject",
        data:{
            categoryname: name
        },
        dataType: "json",
        success: function(response){
            $("select#subcategory_selectlist").empty();
            $.each(response, function(key, value){
                $("select#subcategory_selectlist").append('<option value='+ key +'>'+ value +'</option>');
            });
        },
        error: function(error){
            console.log("error: ");
            console.log(error);
        }
    });
}

function populateBrandsSuppliers(brand,supplier,ve){
    console.log(ve);
    var brandselectlist = "#" + brand;
    var supplierselectlist = "#" + supplier;
    $(brandselectlist).empty();
    $(supplierselectlist).empty();
    $.ajax({
        url: "cfc/admin.cfc?method=getBrands",
        dataType: "json",
        success: function(response){
            $.each(response, function(key,value){
                $(brandselectlist).append("<option value="+ key +">"+ value +"</option>");
            });
            if(ve != undefined){ $(brandselectlist).val(ve.bid); }   // populating in  (view edit form)
        }
    });
    $.ajax({
        url: "cfc/admin.cfc?method=getSuppliers",
        dataType: "json",
        success: function(response){
            $.each(response, function(key,value){
                $(supplierselectlist).append("<option value="+ key +">" + value + "</option>");
            });
            if( ve != undefined){ $(supplierselectlist).val(ve.sid); }  //ve contains all
        }
    });
    $("#ve_product_view_edit_form").validate();
}


function getProductsAndShow(){     //after click retrieve products  (product action button)
    var categoryid = $("#category_selectlist").children("option:selected").data("categoryid"); //data("categoryid");
    var subcategoryid = $("#subcategory_selectlist").val();
    // alert(categoryid + " " + subcategoryid);
    $("#products-list").empty();
    $("#products-info").empty();
    $.ajax({
        url: "cfc/admin.cfc?method=getProducts",
        data: { scatid: subcategoryid },
        dataType: "json"
    }).done(function(response){
        console.log("success");
        $.each(response , function(index, item){
            $("#products-list").append("<div class='products nav nav-tabs nav-stacked' data-product-id='"+item.ProductId+"' data-brand-id='"+item.BrandId+"' data-list-price='"+item.ListPrice+"' data-description='"+item.Description+"' data-name='"+item.Name+"' data-qty='"+item.Qty+"' data-supplier-id='"+item.SupplierId+"' data-subcategory-id='"+item.SubCategoryId+"' onclick="+ "showProduct(this);populateBrandsSuppliers('ve_brands_select_list','ve_suppliers_select_list',getBrandSellerId(this));" +"><a>"+ item.Name +"</a></div>");
        });
    }).fail(function(error){
        console.log("error");
        console.log(error);
    });
}

function getBrandSellerId(el){
    var bid = $(el).data('brandId')
    var sid = $(el).data('supplierId');
    var ve = {
        bid: bid,
        sid: sid
    }
    return ve;
}

function showProduct(prdt_div){
    var productForm =   '<form class="" action="" enctype="multipart/form-data" method="post" id="ve_product_view_edit_form" name="product_add_form">'
                            +'<div id="ve_form-header">add new product</div>'

                            +'<div class="form-group">'
                                +'<label>Product Name: </label>'
                                +'<input type="text" name="Name" value="'+$(prdt_div).data("name")+'"  required>'
                            +'</div>'
                            +'<div class="form-group">'
                                +'<label>Brand: </label>'
                                +'<select name="BrandId" id="ve_brands_select_list" required>'
                                +'</select>'
                            +'</div>'

                            +'<div class="form-group">'
                                +'<input  name="SubCategoryId" id="ve_subCategoryValue" type="hidden" value="'+$(prdt_div).data("subCategoryId")+'" required/>'
                            +'</div>'

                            +'<div class="form-group">'
                                +'<label>Suppliers: </label>'
                                +'<select name="SupplierId" id="ve_suppliers_select_list" required>'
                                +'</select>'
                            +'</div>'
                            +'<div class="form-group">'
                                +'<label>Stock Quantity: </label>'
                                +'<input type="number" min="0" name="Qty" value="'+$(prdt_div).data("qty")+'" required/>'
                            +'</div>'
                            +'<div class="form-group">'
                                +'<label>ListPrice(&#8377;): </label>'
                                +'<input type="number" min="0" name="ListPrice" value="'+$(prdt_div).data("listPrice")+'"  required />'
                            +'</div>'
                            +'<div class="form-group">'
                                +'<label>Description: </label>'
                                +'<textarea name="Description" cols="22" rows="4">'+$(prdt_div).data("description")+'</textarea>'
                            +'</div>'
                            +'<div class="form-group">'
                                +'<label>Update Images File: </label>'
                                +'<input type="file" id="ve_imageFile" name="Image" accept="image/jpeg" required>'
                            +'</div>'
                            +'<div class="form-group">'
                                +'<button type="button" name="edit"  class="btn btn-sm btn-success">Edit</button>'
                                +'<button type="submit" name="submit"class="btn btn-sm btn-success">Update Product</button>'
                                +'<button type="reset" name="reset"  class="btn btn-sm btn-default">Clear</button>'
                            +'</div>'
                        +'</form>';
    $("#products-info").html( "<div class=''>" + productForm + "</div>"); //.addClass("no-background");
}
function addBrands(el){
    var BrandName = $(el).prev().val();
                    $(el).next().children(".list").append("<p class='list-item'>" + BrandName + "</p>");
}

function addSubCategory(el){
    var inputElement = $(el).prev();
    var categoryid = inputElement.data('categoryid');
    var categoryname = inputElement.data('categoryname');
    var SubCategoryName = ($(el).prev().val()).trim();
    
    if( SubCategoryName != ""){
        $.ajax({
            url: "cfc/admin.cfc?method=addSubCategory",
            data: { categoryid : categoryid, subcategoryname : SubCategoryName },
            dateType: "JSON",
            success: function(res){
                console.log("added " + SubCategoryName);  //update Database
                $(el).next().children(".list").append("<p class='list-item'>" + SubCategoryName + "</p>"); //Update UI
            },
            error:function(err){
                console.log(err);
            }
        });
    }
    else{
        alert('no name');
    }
}

function enableSubCategoryTextField(el){
    $(".cnb-subcategory .list").empty();

    var categoryname = $(el).find(":selected").val();
    var categoryid = $(el).find(":selected").attr('id');

    if( categoryname != "invalid" ) {
        $.ajax({
            url: "cfc/admin.cfc?method=getSubCategoriesJSON",
            data: { categoryid: categoryid },
            dataType: "json",
            success:function(arr){
                console.log(arr);
                $.each(arr, function(i, item){
                    $(".cnb-subcategory .list").append("<p class='list-item'>" + item + "</p>")
                });
            }
        });
        $("#subcategory_textbox").data('categoryid', categoryid);
        $("#subcategory_textbox").data('categoryname', categoryname);
        $("#subcategory_textbox").prop('disabled', false);
    }
    else{
        $("#subcategory_textbox").prop('disabled', true);
    }
}
