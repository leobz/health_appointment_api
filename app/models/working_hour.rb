  class WorkingHour < ApplicationRecord
    belongs_to :doctor

    #****************************** Validations *****************************
    validates :day_of_week, :start_time, :end_time, presence: true
    validates :start_time, comparison: { less_than: :end_time, message: 'must be before end_time' }
    validate  :validate_no_overlapping_hours

    #***************************** Attributes ********************************
    enum :day_of_week, sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6

    private

    # Prevent overlapping working hours for the same doctor and day.
    # Ensures the new 'start_time' and 'end_time' does not fall within existing intervals.
    def validate_no_overlapping_hours
      overlapping_hours =
        WorkingHour.where(doctor_id: doctor_id, day_of_week: day_of_week)
         .where.not(id: id)
         .where("start_time < ? AND end_time > ?", end_time, start_time)

      if overlapping_hours.exists?
        errors.add(:base, "Working hours cannot overlap with existing working hours")
      end
    end
  end