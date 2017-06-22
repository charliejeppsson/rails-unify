class AddPublicToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :is_public, :boolean, default: false
  end
end
