class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :title
      t.string :description
      t.datetime :start_time
      t.datetime :end_time
      t.string :organization
      t.string :category
      t.string :location
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
