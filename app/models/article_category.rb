class ArticleCategory < ActiveRecord::Base
  attr_accessible :name, :description

  belongs_to :parent, class_name: 'ArticleCategory'

  has_many :articles, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 50

end
