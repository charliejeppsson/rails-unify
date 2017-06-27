class Contact < ApplicationRecord
  include PgSearch
  belongs_to :user
  belongs_to :user_contact, class_name: 'User'

  pg_search_scope :global_search,
    against: [ :notes, :category ],
    associated_against: {
      user_contact: [ :first_name, :last_name, :industry ]
    }, using: {tsearch: {prefix: true, any_word: true}}

end

