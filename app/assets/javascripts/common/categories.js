$(document).ready(function() {
    $.getJSON('/categories.json', function(data, status) {
        //articles categories
        var parent = $("#categories");
        multi_categories(data['categories'], parent);

        var categories_main_ul = $("#categories > ul");
        categories_main_ul.find("li:first").before('<li>类别列表</li>').parent().find('li:first').css('background-color', 'lightblue');
        categories_main_ul.show();

        //articles categories click event
        category_item_click_event();
    });
});