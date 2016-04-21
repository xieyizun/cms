var category_form = null;
var categories = null;

$(document).ready(function() {
    $.getJSON('/categories.json', function(data, status) {
        //articles categories
        //var parent = $("#categories");

        //categories = data['categories'];

        //multi_categories(data['categories'], parent, false);
        multilCategories2(data, false);

        var categories_main_ul = $("#categories > ul");
        categories_main_ul.find("li:first").before('<li>类别列表</li>').parent().find('li:first').css('background-color', 'lightblue');
        categories_main_ul.show();

        //填充可选的父类别
        if (data['categories'] != undefined) {
           fillSelectableCategoriesOptions(data);
        }

        //articles categories click event
        show_category_children();
        show_category_detail();
    });
});

function show_category_detail() {
    $("img.show_category").on('click', function() {
        var category_info = $("div.category_articles");

        if ($(this).attr('src') == '/assets/show_category.png') {
            $(this).attr('src', '/assets/hide_category.png');
            if (category_form == null) {
                var form = category_info.find('#form');
                category_form = form;
            }

            var category_id = $(this).parent().attr("value");

            //异步加载类别详细信息
            var data = {
                url: '/detail.json',
                data: { category_id: category_id },
                type: "GET",
                success: function(data) {
                    var category = data['category'];

                    var category_detail = category_detail_html(category);
                    category_info.find('#form').replaceWith(category_detail);

                    //填充可选的父任务
                    fill_selectable_categories_options(categories);
                }
            }
            $.ajax(data);


        } else {
            $(this).attr('src', '/assets/show_category.png');

            category_info.find("#form").replaceWith(category_form);
        }
    });
}

function category_detail_html(category) {
    var detail_html =
        '<form id="form" action="/categories/' + category.id + '" method="post">' +
            '<div>' +
                '<div>类别名称</div>' +
                '<input type="text"  name="category[name]" id="category_name" value="' + category.name + '" />'+
            '</div>' +
            '<div id="category_description">' +
                '<div>描述</div>' +
                '<textarea name="category[description]" id="category_description">' + category.description + '</textarea>' +
            '</div>';

 /*   if (category.parent_id != null) {
        var parent_html = '<div><div>父类别</div>' +
            '<select class="selectable_categories" name="category[parent_id]">' +
            '<option value="' + category.parent_id + '">' + category.parent_name + '</option>' +
            '</select></div>';
        detail_html += parent_html;
    } else {*/
        var parent_html = '<div><div>父类别</div>' +
                '<select class="selectable_categories" name="category[parent_id]" id="category_description">' +
                '<option>-----</option>' +
                '</select></div>';
        detail_html += parent_html;


        var update_submit = '<div id="update_category">' +
                '<input type="submit" id="update_category_info" value="更新"' + '/>' +
            '</div>' +
        '</form>';

        detail_html += update_submit;

    return detail_html;
}


