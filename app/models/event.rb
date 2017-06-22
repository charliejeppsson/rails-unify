class Event < ApplicationRecord

CATEGORIES = ['Tech', 'Human Resources', 'Education', 'Innovation', 'Healthcare']
  belongs_to :user
  has_many :attendances, dependent: :destroy

end
