$(document).ready(function() {
    $.getJSON('/categories.json', function(data, status) {
        //articles categories
        var parent = $("#categories");
        multi_categories(data['categories'], parent);

        var categories_main_ul = $("#categories > ul");
        categories_main_ul.find("li:first").before('<li>类别列表</li>').parent().find('li:first').css('background-color', 'lightblue');
        categories_main_ul.show();

        //填充可选的父类别
        if (data['categories'] != undefined) {
            fill_selectable_categories_options(data['categories']);
        }
        //articles categories click event
        category_item_click_event();

        inspect_if_category_info_is_ok();
    });
});

function inspect_if_category_info_is_ok() {
    //检测类别信息是否完整
    $("#submit_category_info").on('click', function(){
        var category_name = $("#category_name").value();
        if (category_name.length == 0) {
            $("#category_name").append('<p>类别名称不能为空</p>');
            return false;
        }
    });
}

