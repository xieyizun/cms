class ArticleCategory < ActiveRecord::Base
  attr_accessible :name, :description

  has_many :articles, dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 50

end
