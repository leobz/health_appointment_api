class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  validates :start_time, presence: true
  validate  :validate_start_time_within_doctor_working_hours

  def end_time
    self.start_time + self.doctor.time_slot_per_client_in_min.minutes
  end

  private

  def validate_start_time_within_doctor_working_hours
    working_hour_exist = doctor.working_hours.any? {|working_hour| working_hour.valid_appointment?(self) }

    unless working_hour_exist
      errors.add(:start_time, "must be within the doctor's working hours")
    end
  end
end
