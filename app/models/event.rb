class Event < ApplicationRecord
  validates :name, presence: true
  validates :category, presence: true
  validates :location, presence: true
  validates :event_time, presence: true
  validates :description, presence: true

  belongs_to :user
end
