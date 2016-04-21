var current_page = 1;
var all_pages_count = null;

var display_last = 0;
var display_first = 0;


$(document).ready(function() {
    $.getJSON("/home.json", function(data, status) {

        categories_and_articles_view(data);

        //主页实现分页
        var current_user = false;
        var category_id = -1;
        //主页文章数据
        paginate_of_pages(data['pages_count'], current_user, category_id,
                            current_page, display_first, display_last, all_pages_count);

        //响应类别点击事件,返回该类别对应的文章
        //主页不指定current_user
        var url = '/home.json';
        show_articles_of_category(url, current_user, current_page, display_first, display_last, all_pages_count);
    });
});
