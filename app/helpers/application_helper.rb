module ApplicationHelper
  def localize_var(var)
    I18n.t var
  end
end
