  class WorkingHour < ApplicationRecord
    belongs_to :doctor

    validates :day_of_week, :start_time, :end_time, presence: true
    validates :start_time, comparison: { less_than: :end_time, message: 'must be before end_time' }
    validate  :validate_no_overlapping_hours
    # IMPORTANT: This order match with Date.wday and Date::DAYNAMES. DON'T CHANGE IT.
    enum :day_of_week, {sunday: 0, monday: 1, tuesday: 2, wednesday: 3, thursday: 4, friday: 5, saturday: 6}

    def valid_appointment?(appointment)
      # TODO: Add holidays validation. See https://github.com/holidays/holidays
      valid_appointment_day_of_week?(appointment) && valid_appointment_time?(appointment)
    end

    # Returns a list of times between the :start_time and :end_time using the doctor time interval
    # Example: [Time("09:00"), Time("10:00"), Time("11:00")]
    def to_times
      times = []
      iteration_time = self.start_time

      while iteration_time < self.end_time
        times << iteration_time
        iteration_time += doctor.time_slot_per_client_in_min.minutes
      end

      times
    end

    private

    # Get the integer representation of :day_of_week. Example: monday -> 1
    def integer_day_of_week
      read_attribute_before_type_cast(:day_of_week)
    end

    #***************************  Appointments Validations ************************
    # Validate if appointment falls on the :day_of_week
    def valid_appointment_day_of_week?(appointment)
      integer_day_of_week.eql? appointment.start_time.wday
    end

    # Validate if appointment falls within :start_time and :end_time
    def valid_appointment_time?(appointment)
      TimeUtils.extract_time(appointment.start_time) >= TimeUtils.extract_time(self.start_time) &&
        TimeUtils.extract_time(appointment.start_time) <= TimeUtils.extract_time(self.end_time)
    end

    #**************************** Model Validations ******************************
    # Prevent overlapping working hours for the same doctor and day, within existing time intervals.
    def validate_no_overlapping_hours
      overlapping_hours =
        WorkingHour
          .where(doctor_id: doctor_id, day_of_week: day_of_week)
          .where.not(id: id)
          .where("start_time <= ? AND end_time >= ?", end_time, start_time)

      if overlapping_hours.exists?
        errors.add(:base, "Working hours cannot overlap with existing working hours")
      end
    end
  end