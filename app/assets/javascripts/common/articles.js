var div_articles_html = null;

$(document).ready(function() {
    $.getJSON("/articles.json", function(data, status) {
        categories_and_articles_view(data);

        $("div#new_article").delegate('input','click', function(){
            var div_articles = $("div#reuseable_area");
            /* if (div_articles_html == null) {
             div_articles_html = div_articles.html();
             }*/
            div_articles.html(new_article_html());
            fill_selectable_categories_options(data['categories']);

        });

        $("div.container").delegate('button', 'click', function() {
            $("div#new_article_form form").submit();
            //$("div#new_article_form").replaceWith(div_articles_html);
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
                        '<option>-----</option>' +
                    '</select>' +
                '</div>' +
                '<div id="create_article_button"><button id="create_article">创建</button></div>' +
            '</form>' +
        '</div>';
    return html;
}