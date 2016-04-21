var current_page = 1;
var all_pages_count = null;

var display_last = 0;
var display_first = 0;

$(document).ready(function() {
    $.getJSON("/articles.json?current_user=true", function(data, status) {
        categories_and_articles_view(data);

        //个人页实现分页
        var current_user = true;
        var category_id = -1;
        // 个人文章管理首页数据
        paginate_of_pages(data['pages_count'], current_user, category_id,
            current_page, display_first, display_last, all_pages_count);

        //响应类别点击事件,返回该类别对应的文章
        //个人页指定current_user
        var url = '/articles.json';
        show_articles_of_category(url, current_user,
            current_page, display_first, display_last, all_pages_count);


        $("div#new_article").delegate('input','click', function(){
            var div_articles = $("div#reuseable_area");
            div_articles.html(new_article_html());
            fillSelectableCategoriesOptions(data);
        });

        $("div.container").delegate('button', 'click', function() {
            $("div#new_article_form form").submit();
        });
    });
});

function new_article_html() {
    var html =
        '<div id="new_article_form">' +
            '<form action="/articles/" method="post">' +
                '<div>' +
                    '<div>标题</div>' +
                    '<div><input type="text" name="article[title]"/></div>'+
                '</div>' +
                '<div>' +
                    '<div>文章内容</div>' +
                    '<div><textarea name="article[content]"></textarea></div>' +
                '</div>' +
                '<div>' +
                    '<div>文章类别</div>' +
                    '<select class="selectable_categories" name="article[category]">' +
                    '</select>' +
                '</div>' +
                '<div id="create_article_button"><button id="create_article">创建</button></div>' +
            '</form>' +
        '</div>';
    return html;
}