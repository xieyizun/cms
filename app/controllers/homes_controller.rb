class HomesController < ApplicationController
  def index
    # id, c_name, children(cgs)
    categories = { cgs: [
                    {id: 1, c: '类别1', cgs: [{id: 11, c: '类别11', cgs: [{id: 111, c: '类别111'}]}, {id: 12, c: '类别12',  cgs: [{id: 121, c: '类别121'}]}, {id: 13, c: '类别13'}]},
                    {id: 2, c: '类别2'},
                    {id: 3, c: '类别3'}]}

    articles = { articles: [
                    {id: 1, title: 't1', category: 'c1', time: '2015-5-5', author: 'xyz'},
                    {id: 2, title: 't2', category: 'c1', time: '2024-3-3', author: 'xyz'},
                    {id: 3, title: 't3', category: 'c1', time: '2015-5-5', author: 'xyz'},
                    {id: 4, title: 't4', category: 'c1', time: '2024-3-3', author: 'xyz'}]}

    test = { ts: [{id: 1, title: '1221'}]}

    respond_to do |format|
      format.json { render :json => {
                                      :categories => categories,
                                      :articles => articles,
                                      :test => test
                                    }
      }
      format.html
    end
  end
end
