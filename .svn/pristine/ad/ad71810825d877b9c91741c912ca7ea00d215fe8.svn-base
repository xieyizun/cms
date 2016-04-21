$(document).ready(function(){
    var article_id = $("div#article_id").text();

    $.getJSON('/articles/' + article_id + '.json', function(data, status) {
        var article = data['article'];

        $("div#title").append('<span>' + article.title + '</span>');
        $("div#content").html(article.content);

        var others = $("div#others");
        if (data['edit_option'] != undefined) {
            others.append('<div><a href="/articles/' + data['edit_option'] + '/edit"' + '>编辑</a></div>');
            others.append('<div><a href="/articles/' + data['edit_option'] + '">删除</a></div>');
        }

        others.append('<div>创建时间：' + article.created_on + '</div>');
        others.append('<div>访问次数：' + data['view_count'] + '</div>');
        others.append('<div>类别：' + article.category + '</div>');
        others.append('<div>作者：' + article.author + '</div>');
        others.append('<div>hello</div>');

    });
});