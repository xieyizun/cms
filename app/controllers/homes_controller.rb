class HomesController < ApplicationController

  def me
    me_options = { current_user: {me: localize_var(:label_me), logout: localize_var(:label_logout)}}
    login_options = { login_options: {login: localize_var(:label_login), register: localize_var(:label_register)} }

    respond_to do |format|
      format.json {
        if sign_in?
          render :json => { :me_options => me_options }
        else
          render :json => { :login_options => login_options }
        end
      }
      format.html
    end
  end

  def index
    if params[:page_id].blank?
      respond_to do |format|
        format.json {
          cgs = ArticleCategory.get_json_tree_of_categories
          categories = { cgs: cgs}

          #文章列表
          articles = { articles: Article.get_latest_articles }
          #页数
          articles_pages_count = Article.get_articles_pages_count

          render :json => { :categories => categories, :articles => articles, :pages_count => articles_pages_count }
        }

        format.html
      end
    else
      #异步加载每一页的文章
      respond_to do |format|
        format.json {
          page_id = params[:page_id]
          articles = { articles: Article.get_latest_articles(page_id.to_i) }

          render :json  => { :articles => articles }
        }
      end
    end
  end
end
