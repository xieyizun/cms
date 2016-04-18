class ArticleCategory < ActiveRecord::Base
  attr_accessible :name, :description, :parent_id

  #belongs_to :parent, class_name: 'ArticleCategory'
  belongs_to :parent, class_name: 'ArticleCategory', foreign_key: 'parent_id'

  has_many :child_categories, class_name: 'ArticleCategory', foreign_key: 'parent_id'

  has_many :articles, foreign_key: 'category_id', dependent: :destroy

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_length_of :name, maximum: 50


  def self.create_category_from_params(name, description, parent_id)
    category = ArticleCategory.new(name: name, description: description, parent_id: parent_id)
    if category.save
      true
    else
      false
    end
  end

  def self.get_json_tree_of_categories
    categories_without_parent = ArticleCategory.where(parent_id: nil)
    build_json_tree_of_categories(categories_without_parent)
  end

  def self.build_json_tree_of_categories(parent_categories)
    categories_json_tree = []

    parent_categories.each do |parent|
      category_with_children = {}
      category_with_children[:id] = parent.id
      category_with_children[:c] = parent.name

      if parent.child_categories.length != 0
        #递归构建类别json树
        category_with_children[:cgs] = build_json_tree_of_categories(parent.child_categories)
      end

      categories_json_tree << category_with_children
    end

    categories_json_tree
  end
end
