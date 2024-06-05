class Appointment < ApplicationRecord
  belongs_to :doctor
  belongs_to :patient

  validates :start_time, presence: true
  validate  :start_time_within_doctor_working_hours


  private

  def start_time_within_doctor_working_hours
    working_hour =
      WorkingHour
        .where(doctor_id: doctor.id)
        .where(day_of_week: start_time.wday)
        .where("start_time >= ? AND  end_time <= ?", start_time, start_time)

    unless working_hour.exists?
      errors.add(:start_time, "must be within the doctor's working hours")
    end
  end
end
