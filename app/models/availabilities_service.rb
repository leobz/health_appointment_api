# This class returns a list of Availabilities within a date range
class AvailabilitiesService
  def self.call(*args)
    self.new(*args).call
  end

  def initialize(doctor, start_date, end_date)
    @start_date = start_date
    @end_date = end_date
    @slot_duration_in_min = doctor.time_slot_per_client_in_min
    @doctor_working_hours_per_day = doctor.working_hours_per_day
    @doctor_appointments_per_date = doctor.appointments_per_date(@start_date, @end_date)
  end

  def call
    (@start_date..@end_date)
      .filter { |date| working_hours_available_for_date?(date) }
      .map    { |date| build_availability(date) }
  end

  private

  # Build availability for an specific date using pre-load data-structures to avoid multiple DB queries per date.
  # The pre-loaded data structures, consisting of a range of dates, include appointments and working hours.
  def build_availability(date)
    appointments = get_appointments(date)
    working_hours = get_working_hours(date)

    Availability.new(@slot_duration_in_min, date, appointments, working_hours)
  end

  def working_hours_available_for_date?(date)
    get_working_hours(date).present?
  end

  def get_working_hours(date)
    @doctor_working_hours_per_day[TimeUtils.day_name(date)]
  end

  def get_appointments(date)
    @doctor_appointments_per_date[date.to_s]
  end
end