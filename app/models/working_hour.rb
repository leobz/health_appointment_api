class WorkingHour < ApplicationRecord
  belongs_to :doctor

  #****************************** Validations *****************************
  validates :day_of_week, :start_time, :end_time, presence: true

  # Prevent overlapping working hours for the same doctor and day.
  validates_uniqueness_of :start_time,
    scope: [:doctor_id, :day_of_week],
    conditions: ->(working_hour) { overlapping_conditions(working_hour) }

  #***************************** Attributes ********************************
  enum :day_of_week, sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6

  private
  # Ensures the new 'start_time' and 'end_time' does not fall within existing intervals.
  def self.overlapping_conditions(working_hour)
    where("start_time <= ? and end_time >= ?", working_hour.end_time, working_hour.start_time)
  end
end