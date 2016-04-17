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
    # id, c_name, children(cgs)
    cgs = ArticleCategory.get_json_tree_of_categories
    categories = { cgs: cgs}

    articles = { articles: Article.get_latest_articles }

    me_options = { current_user: {me: localize_var(:label_me), logout: localize_var(:label_logout)}}
    login_options = { login_options: {login: localize_var(:label_login), register: localize_var(:label_register)} }

    respond_to do |format|
      format.json {
        if sign_in?
          render :json => { :categories => categories, :articles => articles, :me_options => me_options }
        else
          render :json => { :categories => categories, :articles => articles, :login_options => login_options }
        end
      }
      format.html
    end
  end
end
