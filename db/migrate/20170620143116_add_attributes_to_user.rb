class AddAttributesToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :headline, :string
    add_column :users, :industry, :string
    add_column :users, :location, :string
    add_column :users, :date_of_birth, :datetime
  end
end
