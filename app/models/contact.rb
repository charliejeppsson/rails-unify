class Contact < ApplicationRecord
    belongs_to :user
    belongs_to :user_contact, class_name: 'User'

end
