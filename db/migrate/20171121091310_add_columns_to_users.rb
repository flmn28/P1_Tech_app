class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :uid, :string
    add_column :users, :provider, :string
    add_column :users, :education, :string
    add_column :users, :username, :string
    add_column :users, :image, :string, default: 'default_icon.png'
    add_column :users, :token, :string
  end
end
