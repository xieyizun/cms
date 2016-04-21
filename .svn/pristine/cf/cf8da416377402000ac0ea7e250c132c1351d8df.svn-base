// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
// require_tree .

$(document).ready(function() {

    $.getJSON('/me.json', function(data, status) {
        var me_nav = $("#me");
        //用户登陆
        if (data['me_options'] != undefined) {
            var me_options = data['me_options'];
            me_nav.find(' > label').text(me_options.current_user.me);
            me_nav.find(' > ul').append('<li><a href="/signout">' + me_options.current_user.logout +
            '</a></li>');
        } else {
            //普通访问
            var login_options = data['login_options'];

            me_nav.find(' > label').text(login_options.login_options.login);
            var me_option_ul = me_nav.find(' > ul');
            me_option_ul.append('<li><a href="/signin">' + login_options.login_options.login +
            '</a></li>');
            me_option_ul.append('<li><a href="/signup">' + login_options.login_options.register +
            '</a></li>');
        }
    });

    //navigations
    $(".navigation > ul > li").not(":last").hover(
        function() {
            $(this).addClass('active_nav');
        },
        function() {
            $(this).removeClass('active_nav');
        }
    );
    //me
    $(".navigation ul li#me").click(
        function() {
            $(this).find('#me_options').slideToggle();
        }
    );

    //注册
    $("#register").on('click', function() {
        $("#register_form").submit();
    });

    //登录
    $("#login").on('click', function() {
        $("#login_form").submit();
    });
});

function multi_categories(categories, parent, show_articles) {
    var categories_ul = parent.append('<ul></ul>').find(" > ul");
    //multi categories
    $.each(categories.cgs, function(i, item) {
        var category = null;
        if (item.cgs != undefined) {
            category = '<li value="' + item.id + '">' +
            '<img class="li_event" src="/assets/downlist.png" />'  + item.c;

            if (show_articles) {
                category += '<img class="show_articles" src="/assets/articles.png" />' + '</li>';
            } else {
                category += '<img class="show_category" src="/assets/show_category.png" />' + '</li>'
            }

            categories_ul.append(category);
            var p = categories_ul.children().last();

            //递归构建目录树
            multi_categories(item, p, show_articles);
        } else {
            category = '<li value="' + item.id + '">' + item.c;

            if (show_articles) {
                category += '<img class="show_articles" src="/assets/articles.png" />' + '</li>';
            } else {
                category += '<img class="show_category" src="/assets/show_category.png" />' + '</li>'
            }

            categories_ul.append(category);
        }
    });
}

function multilCategories2(data, showArticles) {
    var categories = data['categories'];
    var maxLevel = parseInt(data['max_level']);

    var categoriesDiv = $("#categories");
    categoriesDiv.append('<ul id="1"></ul>');

    for (var i=1; i <= maxLevel; i++) {
        var childrenCategories = categories[i];

        for (var j = 0; j < childrenCategories.length; j++) {
            var category = childrenCategories[j];

            var categoryLi = null;

            if (category.has_children == true) {
                categoryLi = '<li value="' + category.id + '">' +
                    '<img class="li_event" src="/assets/downlist.png" />'  + category.name;

                if (showArticles) {
                    var img = '<img class="show_articles" src="/assets/articles.png" />' + '<ul id="' + category.id + '"></ul></li>';
                    categoryLi += img;
                } else {
                    var img = '<img class="show_category" src="/assets/show_category.png" />' + '<ul id="' + category.id + '"></ul></li>';
                    categoryLi += img;
                }

            } else {
                categoryLi = '<li value="' + category.id + '">' +
                    '<img class="li_event" src="/assets/downlist.png" />'  + category.name;

                if (showArticles) {
                    categoryLi += '<img class="show_articles" src="/assets/articles.png" />' + '</li>';
                } else {
                    categoryLi += '<img class="show_category" src="/assets/show_category.png" />' + '</li>'
                }

            }

            //寻找父节点
            var parent_ul = $('div#categories ul[id="' + category.parent_id + '"]');

            parent_ul.append(categoryLi);
        }
    }
}

function show_category_children() {
    $(".li_event").on('click', function() {
        if ($(this).siblings()) {
            if ($(this).attr('src') == '/assets/downlist.png') {
                $(this).attr('src', '/assets/uplist.png');
            } else {
                $(this).attr('src', '/assets/downlist.png');
            }

            $(this).siblings().not(":first").slideToggle();
        }
        //放置当前事件往上传到父类
        return false;
    });
}

function show_articles_of_category(url, current_user, current_page, display_first, display_last, all_pages_count) {

    //异步加载类别对应的文章
    $("img.show_articles").on('click', function() {
        var category_id = $(this).parent().attr('value');

        var opts = {
            url: url,
            type: 'GET',
            data: { category_id: category_id },
            dataType: "json",

            success: function(data) {
                $("#articles table tbody").empty();

                fill_articles_view(data['articles']);
                //显示页码
                paginate_of_pages(data['pages_count'], current_user, category_id,
                                    current_page, display_first, display_last, all_pages_count);
            }
        }

        //其他请求参数: current_user
        if (current_user == true) {
            opts['data']['current_user'] = true;
        }

        $.ajax(opts);
    });
}

function categories_and_articles_view(data) {

    // articles categories
    // var parent = $("#categories");
    // multi_categories(data['categories'], parent, true);

    multilCategories2(data, true);

    var categories_main_ul = $("#categories > ul");
    categories_main_ul.find("li:first").before('<li>类别列表</li>').parent().find('li:first').css('background-color', 'lightblue');
    categories_main_ul.show();

    //articles categories click event
    show_category_children();

    //articles
    fill_articles_view(data['articles']);
}

function fill_selectable_categories_options(categories) {

    var selectable_categories = $(".selectable_categories");

    $.each(categories.cgs, function(i, item){
        selectable_categories.append('<option value="' + item.id + '">' + item.c + '</option>');
        if (item.cgs != undefined) {
            fill_selectable_categories_options(item);
        }
    });
}

function fillSelectableCategoriesOptions(data) {
    var categories = data['categories'];
    var maxLevel = parseInt(data['max_level']);

    var selectable_categories = $(".selectable_categories");

    for (var i = 1; i <= maxLevel; i++) {
        var cgs = categories[i.toString()];
        for (var j = 0; j < cgs.length; j++) {
            var c = cgs[j];
            selectable_categories.append('<option value="' + c.id + '">' + c.name + '</option>');
        }
    }
}

function fill_articles_view(articles) {
    var articles_table = $('div#articles table tbody');
    //articles
    $.each(articles.articles, function(i, item) {
        var row = '<tr><td class="title">' + '<a href="/articles/' + item.id + '">' + item.title + '</a>' + '</td>' +
            '<td class="category">' + item.category + '</td>' +
            '<td class="time">' + item.created_on + '</td>' +
            '<td class="author">' + item.author + '</td></tr>';
        articles_table.append(row);
    });

    $('tr:even').not(':first').css('background-color', 'whitesmoke');
}

//以下代码实现分页
function paginate_of_pages(pages_count, current_user, category_id,
                           current_page, display_first, display_last, all_pages_count) {
    var paginate_ul = $("div.paginate ul");
    paginate_ul.empty();

    all_pages_count = parseInt(pages_count);

    display_first = 1;
    current_page = 1;
    display_last = (pages_count > 10)? 10: pages_count;

    for (var page = 1; page <= display_last; page++) {
        paginate_ul.append('<li id="' + page + '">' + '<a id="page" href="#">' + page + '</a></li>');
    }

    paginate_ul.prepend('<li id="before">' + '<a id="page" href="#">' + '上一页' + '</a></li>');
    paginate_ul.append('<li id="next">' + '<a id="page" href="#">' + '下一页' + '</a></li>');

    //异步获取分页数据
    get_articles_by_page_id(current_user, category_id,  current_page, display_first, display_last, all_pages_count);
}

function get_articles_by_page_id(current_user, category_id, current_page, display_first, display_last, all_pages_count) {

    var paginate_ul = $("div.paginate ul");

    //首先解除绑定,否则随着点击次数的增加会不断叠加ajax请求,发送多长ajax请求
    $("div.paginate ul").off('click', 'a');

    $("div.paginate ul").on('click', 'a', function() {
        var li = $(this).parent();
        var page_id = li.attr('id');

        if (page_id == 'before') {
            if (current_page == 1)
                return;
            current_page = current_page - 1;
        } else if (page_id == 'next') {
            if (current_page == all_pages_count || all_pages_count == 0)
                return;
            current_page = current_page + 1;
        } else {
            current_page = parseInt(page_id);
        }

        var opts = {
            url: '/page.json',
            data: { page_id: current_page },
            type: 'GET',
            success: function(data) {
                var articles = data['articles'];

                $("div#articles table tbody").empty();

                fill_articles_view(articles);

                //超过10页
                if (current_page >= display_last && all_pages_count > display_last) {
                    display_last = display_last + 1;
                    paginate_ul.find('li:first').next().remove();
                    display_first = display_first + 1;
                    paginate_ul.find('li:last').before('<li id="' + display_last + '">' + '<a id="page" href="#">' + display_last + '</a></li>');
                }

                //往回翻
                if (current_page < display_first) {
                    display_first = display_first - 1;

                    paginate_ul.find('li:last').prev().remove();

                    display_last = display_last - 1;
                    paginate_ul.find('li:first').after('<li id="' + display_first + '">' + '<a id="page" href="#">' + display_first + '</a></li>')
                }

                //显示当前选中的页码
                display_selected_page_id(current_page);
            }
        }

        if (current_user == true) {
            opts['data']['current_user'] = true;
        }

        if (category_id != -1) {
            opts['data']['category_id'] = category_id;
        }

        $.ajax(opts);
    });
}

function display_selected_page_id(current_page) {
    $("div.paginate ul li").attr('id', function(i, val) {
        if (val == current_page) {
            $(this).find('a').css('background-color', 'lightblue');
        } else {
            $(this).find('a').css('background-color', 'whitesmoke');
        }
    });
}



