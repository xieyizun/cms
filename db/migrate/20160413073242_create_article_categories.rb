class CreateArticleCategories < ActiveRecord::Migration
  def self.up
    create_table :article_categories do |t|
      t.column :name, :string, limit: 50, unique: true, default: "", null: false
      t.column :description, :text
    end
  end

  def self.down
    drop_table :article_categories
  end
end
