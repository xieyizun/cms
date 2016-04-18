

$(document).ready(function() {
    $.getJSON("/articles.json", function(data, status) {
        categories_and_articles_view(data);
        paginate_of_pages(data['pages_count']);
    });
});
