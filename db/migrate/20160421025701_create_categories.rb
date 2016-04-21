class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.column :name, :string, limit: 50, unique: true, default: "", null: false
      t.column :description, :text
      t.column :lft, :integer, default: 0, null: false
      t.column :rgt, :integer, default: 0, null: false

      t.column :level, :integer, default: 0, null: false
    end

    add_index :categories, :lft
    add_index :categories, :rgt
    add_index :categories, :level

  end

  def self.down
    drop_table :categories
  end
end
