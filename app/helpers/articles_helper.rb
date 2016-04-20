module ArticlesHelper
  include SessionsHelper

  def if_current_user_is_owner(ownername)
    if sign_in?
      current_user.name == ownername
    else
      return false
    end
  end

  def correct_user?
    @article = Article.find(params[:id])
    unless current_user.id == @article.user_id
      redirect_to article_path @article, notice: localize_var(:field_only_owner_can_edit)
    end
  end
end
