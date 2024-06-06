class Doctor < ApplicationRecord
  has_many :working_hours, dependent: :delete_all
  has_many :appointments

  validates :first_name, :last_name, presence: true

  def get_availabilities(start_date, end_date)
    slot_manager = SlotManager.new(self, start_date, end_date)
    slot_manager.get_availabilities
  end

  def working_hours_per_day
    working_hours_per_day = Hash.new {|hsh, key| hsh[key] = [] }

    working_hours.each do |working_hour|
      working_hours_per_day[working_hour.day_of_week] << working_hour
    end

    working_hours_per_day
  end

  def get_appointments(start_date, end_date)
    appointments.where('start_time >= ? AND  start_time <= ?', start_date, end_date)
  end

  def appointments_per_date(start_date, end_date)
    appointments_per_date = Hash.new {|hsh, key| hsh[key] = [] }

    get_appointments(start_date, end_date).each do |appointment|
      appointments_per_date[appointment.start_time.to_date.to_s] << appointment
    end

    appointments_per_date
  end
end
