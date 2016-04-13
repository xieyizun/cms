class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.column :email, :string, limit: 50, unique: true, null: false
      t.column :name, :string, limit: 25, unique: true, null: false
      t.column :password_digest, :string, default: "", null: false
      t.column :remember_token, :string, limit: 16, null: false #remember user long time with cookie

      t.column :is_admin, :boolean, default: false, null: false
    end

    add_index :users, [:email], name: 'users_email'
    add_index :users, [:name], name: 'users_name'
    add_index :users, [:remember_token], name: 'users_remember_token'

  end

  def self.down
    drop_table :users
  end
end
