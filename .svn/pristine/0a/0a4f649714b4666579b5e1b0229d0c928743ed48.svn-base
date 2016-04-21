class HomesController < ApplicationController

  def me
    me_options = {current_user: { logout: localize_var(:label_logout)}}
    login_options = {login_options: {login: localize_var(:label_login), register: localize_var(:label_register)}}

    respond_to do |format|
      format.json {
        if sign_in?
          me_options[:current_user][:me] = current_user.name
          render :json => {:me_options => me_options}
        else
          render :json => {:login_options => login_options}
        end
      }
      format.html
    end
  end

  def index
    respond_to do |format|
      format.json {
        #返回不指定类别的文章
        if params[:category_id].blank?
          # cgs = ArticleCategory.get_json_tree_of_categories
          # categories = {cgs: cgs}

          cgs, max_level = Category.get_categories_json_tree

          articles = {articles: Article.get_latest_articles}
          articles_pages_count = Article.get_articles_pages_count
          render :json => { :categories => cgs, :max_level => max_level,  :articles => articles, :pages_count => articles_pages_count}
          #返回指定类别的文章
        else
          #主页某一类别文章
          ats_json, pages_count = Article.get_articles_and_articles_pages_count_by_category(params[:category_id])
          articles = {articles: ats_json}
          render :json => {:articles => articles, :pages_count => pages_count}
        end
      }
      format.html
    end
  end
end
