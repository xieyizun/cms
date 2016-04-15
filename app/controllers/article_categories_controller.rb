class ArticleCategoriesController < ApplicationController
  def index
    # id, c_name, children(cgs)
    categories = { cgs: [
        {id: 1, c: '类别1', cgs: [{id: 11, c: '类别11', cgs: [{id: 111, c: '类别111'}]}, {id: 12, c: '类别12',  cgs: [{id: 121, c: '类别121'}]}, {id: 13, c: '类别13'}]},
        {id: 2, c: '类别2'},
        {id: 3, c: '类别3'}]}

    respond_to do |format|
      format.json { render :json => { :categories => categories } }
      format.html
    end
  end

  def new
  end

  def show
  end

  def edit
  end
end
