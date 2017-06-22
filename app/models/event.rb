class Event < ApplicationRecord

  belongs_to :user
  has_many :attendances, dependent: :destroy

  def now?
    self.start_time <= (Time.now - 10.minutes) and self.end_time >= Time.now
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
