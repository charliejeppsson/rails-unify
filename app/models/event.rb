class Event < ApplicationRecord

  belongs_to :user
  has_many :attendances, dependent: :destroy
end
