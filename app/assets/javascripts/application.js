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
// require ./common/homes.js
// require_tree .
var current_page = 1;
var all_pages_count = null;

var display_last = 0;
var display_first = 0;

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

function multi_categories(categories, parent) {
    var categories_ul = parent.append('<ul></ul>').find(" > ul");
    //multi categories
    $.each(categories.cgs, function(i, item) {
        var category = null;
        if (item.cgs != undefined) {
            category = '<li value="' + item.id + '">' +
            '<img class="li_event" src="/assets/downlist.png" />'  + item.c +
            '<img class="show_articles" src="/assets/articles.png" />' + '</li>';
            categories_ul.append(category);
            var p = categories_ul.children().last();
            //递归构建目录树
            multi_categories(item, p);
        } else {
            category = '<li value="' + item.id + '">' + item.c +
                       '<img class="show_articles" src="/assets/articles.png" />' + '</li>';
            categories_ul.append(category);
        }
    });
}

function category_item_click_event() {
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

    //异步加载类别对应的文章
    $(".show_articles").on('click', function() {
       var category_id = $(this).parent().attr('value');

       var options = {
           url: '/articles.json',
           type: 'GET',
           data: { category_id: category_id },
           dataType: "json",
           success: function(data) {
               $("#articles table tbody").empty();

               fill_articles_view(data['articles']);
           }
       }
       $.ajax(options);
    });
}

function categories_and_articles_view(data) {

    //articles categories
    var parent = $("#categories");
    multi_categories(data['categories'], parent);

    var categories_main_ul = $("#categories > ul");
    categories_main_ul.find("li:first").before('<li>类别列表</li>').parent().find('li:first').css('background-color', 'lightblue');
    categories_main_ul.show();
    //articles categories click event
    category_item_click_event();

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
function paginate_of_pages(pages_count) {
    var paginate_ul = $("div.paginate ul");

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
    get_articles_by_page_id();
}

function get_articles_by_page_id() {

    var paginate_ul = $("div.paginate ul");

    $("div.paginate").delegate('a', 'click', function() {
        var li = $(this).parent();
        var page_id = li.attr('id');

        if (page_id == 'before') {
            if (current_page == 1)
                return;
            current_page = current_page - 1;
        } else if (page_id == 'next') {
            if (current_page == all_pages_count)
                return;
            current_page = current_page + 1;
        } else {
            current_page = parseInt(page_id);
        }

        var options = {
            url: "/home.json",
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
                display_selected_page_id();
            }
        }

        $.ajax(options);
    });
}

function display_selected_page_id() {
    $("div.paginate ul li").attr('id', function(i, val) {
        if (val == current_page) {
            $(this).find('a').css('background-color', 'lightblue');
        } else {
            $(this).find('a').css('background-color', 'whitesmoke');
        }
    });
}



