class ArticlesController < ApplicationController

  before_filter :inspect_if_sign_in, only: [:index, :create]

  def index
    respond_to do |format|
      format.json {

        #返回不指定类别的文章
        if params[:category_id].blank?
          cgs = ArticleCategory.get_json_tree_of_categories
          categories = { cgs: cgs }
          #主页文章列表
          if params[:current_user].blank?
            articles = { articles: Article.get_latest_articles }
            articles_pages_count = Article.get_articles_pages_count
            render :json => { :categories => categories, :articles => articles, :pages_count => articles_pages_count }
          else
          #个人页文章列表
            ats_json, articles_pages_count = Article.get_my_articles_and_articles_count(current_user)
            # to_json会返回字符串，as_json返回实际的json数组
            articles = { articles: ats_json }
            render :json => { :categories => categories, :articles => articles, :pages_count => articles_pages_count }
          end

        #返回指定类别的文章
        else
          #主页某一类别文章
          if params[:current_user].blank?
            ats_json, pages_count = Article.get_articles_and_articles_pages_count_by_category(params[:category_id])
            articles = { articles: ats_json }

            render :json => { :articles => articles, :pages_count => pages_count }
          else
            #个人页某一类别文章
            ats_json, pages_count = Article.get_articles_and_articles_pages_count_by_category(params[:category_id], current_user)
            articles = { articles: ats_json }

            render :json => { :articles => articles, :pages_count => pages_count }
          end
        end

      }

      format.html
    end
  end

  #此方法专门用于处理文章分页的异步加载请求,返回json数据
  def page
    respond_to do |format|
      format.json {
        page_id = params[:page_id].to_i
        articles = nil

        if params[:category_id].blank?
          if params[:current_user].blank?
            articles = Article.get_articles_of_one_page(page_id)
          else
            articles = Article.get_articles_of_one_page(page_id, current_user)
          end
        else
          if params[:current_user].blank?
            articles = Article.get_articles_of_one_page(page_id, nil, params[:category_id])
          else
            articles = Article.get_articles_of_one_page(page_id, current_user, params[:category_id])
          end
        end

        render :json  => { :articles => articles }
      }
    end
  end

  def create
    created_on = Time.now.localtime
    article = current_user.articles.new(title: params[:article][:title], content: params[:article][:content],
                                        category_id: params[:article][:category], created_on: created_on)
    if article.save
      flash[:success] = localize_var(:label_create_article_successfully)
    else
      flash[:success] = localize_var(:label_create_article_failure)
    end
    redirect_to articles_path
  end

  def show
    @article_id = params[:id]
    article = Article.get_article_by_id(@article_id)
    respond_to do |format|
      format.json { render :json => { :article => article } }
      format.html
    end
  end

  def edit
  end

end
