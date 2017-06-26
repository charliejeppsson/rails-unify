class CreateContacts < ActiveRecord::Migration[5.1]
  def change
    create_table :contacts do |t|
      t.bigint :user_id
      t.bigint :user_contact_id
      t.bigint :event_id
      t.string :notes
      t.string :category

      t.timestamps
    end
  end
end
