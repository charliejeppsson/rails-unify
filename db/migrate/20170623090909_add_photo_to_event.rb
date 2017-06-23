class AddPhotoToEvent < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :photo, :string
  end
end
