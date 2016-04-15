$(document).ready(function() {
    $.getJSON("/articles.json", function(data, status) {
        categories_and_articles_view(data);
    });
});
