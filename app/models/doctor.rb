class Doctor < ApplicationRecord
  has_many :working_hours, dependent: :delete_all
  has_many :appointments

  # TODO: Validate also end_time
  # TODO: Validate max amount of time_slot_per_client_in_in
  validates :first_name, :last_name, :time_slot_per_client_in_min, presence: true


  # Output Example: [Availability<>, Availability<>, ...]
  def get_availabilities(start_date, end_date)
    AvailabilitiesService.call(self, start_date, end_date)
  end

  # Output Example: {"monday": [WorkingHour<>, WorkingHour<>], ... }
  def working_hours_per_day
    working_hours.group_by(&:day_of_week)
  end

  # Output Example: {"2020-01-01": [Appointment<>, Appointment<>], ... }
  def appointments_per_date(start_date, end_date)
    get_appointments(start_date, end_date).group_by {|appointment| appointment.start_time.to_date.to_s }
  end

  def get_appointments(start_date, end_date)
    appointments.where('start_time >= ? AND  start_time <= ?', start_date, end_date)
  end
end
