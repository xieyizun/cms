class Article < ActiveRecord::Base
  attr_accessible :title, :content, :view_count

  belongs_to :user
  belongs_to :category, class_name: 'ArticleCategory', foreign_key: 'category_id'

  validates_presence_of :title, :content, :user_id, :category_id

  default_scope { order('created_on DESC') }

end
