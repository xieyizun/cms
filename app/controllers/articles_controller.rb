class ArticlesController < ApplicationController
  def index
    cgs = ArticleCategory.get_json_tree_of_categories

    categories = { cgs: cgs }

    ats_json = Article.get_my_articles(current_user)
    #to_json会返回字符串，as_json返回实际的json数组
    articles = { articles: ats_json}

    respond_to do |format|
      format.json { render :json => {
          :categories => categories,
          :articles => articles }
      }
      format.html { render html: '/public/articles_template.html' }
    end
  end

  def create
    puts params
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
    puts 'dfas'
    puts request.url

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
