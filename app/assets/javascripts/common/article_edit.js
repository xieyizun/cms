$(document).ready(function(){
    var article_id = $("div#article_id").text();

    $.getJSON('/articles/' + article_id + '.json', function(data, status) {
        var article = data['article'];

        $("div#title").append('<input type="text" name="article[title]"  value="' + article.title + '"/></input>');
        $("div#content").html('<textarea name="article[content]">' + article.content + '</textarea>');

        var others = $("div#others");

        others.append('<div><button id="update_article">更新' + '</button></div>');

        $("button#update_article").on('click', function() {
            $("div.container form#update_article").submit();
        });
    });
});