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

$(document).ready(function() {

    $.getJSON('/me.json', function(data, status) {
        console.log(data);
        var me_nav = $("#me");
        //用户登陆
        if (data['me_options'] != undefined) {
            var me_options = data['me_options'];
            console.log(me_options.current_user.logout);

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
        var category = '<li class="li_event" value="' + item.id + '">' + item.c + '</li>';
        categories_ul.append(category);
        if (item.cgs != undefined) {
            var p = categories_ul.children().last();
            //递归构建目录树
            multi_categories(item, p);
        }
    });
}

function category_item_click_event() {
    $(".li_event").on('click', function() {
        if ($(this).children()) {
            $(this).children().slideToggle();
        }
        //放置当前事件往上传到父类
        return false;
    });
}

function categories_and_articles_view(data) {
    var articles_table = $('#articles table tbody');

    //articles categories
    var parent = $("#categories");
    multi_categories(data['categories'], parent);

    var categories_main_ul = $("#categories > ul");
    categories_main_ul.find("li:first").before('<li>类别列表</li>').parent().find('li:first').css('background-color', 'lightblue');
    categories_main_ul.show();
    //articles categories click event
    category_item_click_event();

    //articles
    $.each(data['articles'].articles, function(i, item) {
        var row = '<tr><td class="title">' + '<a href="/articles/' + item.id + '">' + item.title + '</a>' + '</td>' +
            '<td class="category">' + item.category + '</td>' +
            '<td class="time">' + item.created_on + '</td>';
        if (item.author != undefined) {
            row += '<td class="author">' + item.author + '</td></tr>';
        }
        articles_table.append(row);
    });

    $('tr:even').not(':first').css('background-color', 'whitesmoke');
}

function fill_selectable_categories_options(categories) {

    var selectable_categories = $(".selectable_categories");
    console.log(categories.cgs);

    $.each(categories.cgs, function(i, item){
        selectable_categories.append('<option value="' + item.id + '">' + item.c + '</option>');
        if (item.cgs != undefined) {
            fill_selectable_categories_options(item);
        }
    });
}


