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
end
