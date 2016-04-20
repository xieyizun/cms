class ArticleCategoriesController < ApplicationController

  before_filter :inspect_if_sign_in
  before_filter :inspect_if_is_admin

  def index
    # id, c_name, children(cgs)
    cgs = ArticleCategory.get_json_tree_of_categories

    categories = { cgs: cgs }

    respond_to do |format|
      format.json { render :json => { :categories => categories } }
      format.html
    end
  end

  def detail
    respond_to do |format|
      format.json {
        category = ArticleCategory.get_category_detail_by_id(params[:category_id])
        render :json => { category: category }
      }
    end
  end

  def create
    if params[:category][:parent] =~ /^-/
      params[:category][:parent] = nil
    end

    if ArticleCategory.create_category_from_params(params[:category][:name], params[:category][:description],
                                   params[:category][:parent])
      flash[:success] = localize_var(:field_create_category_successfully_hint)
      redirect_to categories_path
    else
      flash[:failure] = localize_var(:field_create_category_failure_hint)
      redirect_to categories_path
    end
  end

  def show
  end

  def edit
  end

  def update
    if params[:category][:parent_id] =~ /^-/
      params[:category][:parent_id] = nil
    end

    if ArticleCategory.update_category_from_params(params[:id], params[:category])
      flash[:success] = localize_var(:field_update_category_successfully_hint)
      redirect_to categories_path
    else
      flash[:failure] = localize_var(:field_update_category_failure_hint)
      redirect_to categories_path
    end
  end
end
