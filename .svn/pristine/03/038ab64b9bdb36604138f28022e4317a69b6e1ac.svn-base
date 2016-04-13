class CreateArticles < ActiveRecord::Migration
  def self.up
    create_table :articles do |t|
      t.column :user_id, :integer, default: 0, null: false
      t.column :category_id, :integer, default: 0, null: false

      t.column :title, :string, default: "", null: false
      t.column :content, :text, default: "", null: false
      t.column :view_count, :integer, default: 0, null: false

      t.column :created_on, :datetime, null: false
    end

    add_index :articles, [:user_id], name: 'articles_user_id'
    add_index :articles, [:category_id], name: 'articles_category_id'

  end

  def self.down
    drop_table :articles
  end
end
