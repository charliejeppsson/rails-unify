class Event < ApplicationRecord

CATEGORIES = ['Tech', 'Human Resources', 'Education', 'Innovation', 'Food', 'Psychology', 'Design']
  belongs_to :user
  has_many :attendances, dependent: :destroy

  def now?
    self.start_time <= Time.now and self.end_time >= Time.now
    #(- 10.minutes) doesn't work
  end

  def upcomming?
    self.start_time >= Time.now
  end

  def past?
    self.end_time <= Time.now
  end

  geocoded_by :location
  after_validation :geocode, if: :location_changed?

end
