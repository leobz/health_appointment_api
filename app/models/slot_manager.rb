class SlotManager
  Availability  = Struct.new(:date, :time_slots)

  def initialize(doctor, start_date, end_date)
    @doctor = doctor
    @slot_time_in_min = doctor.time_slot_per_client_in_min
    @start_date = start_date
    @end_date = end_date
  end

  def get_availabilities
    availabilities = []

    (@start_date..@end_date).each do |date|
      availability = build_availability(date)
      availabilities << availability if availability
    end

    availabilities
  end

  private

  def build_availability(date)
    return unless working_hours_available_for_date?(date)

    Availability.new(date, build_time_slots(date))
  end

  def build_time_slots(date)
    time_slots = []
    date_appointments = get_appointments(date)

    get_working_hours(date).each do |working_hour|
      iteration_time = working_hour.start_time

      while iteration_time < working_hour.end_time
        time_slot = TimeSlot.new(TimeUtils.build_time(date, iteration_time), @slot_time_in_min)

        unless time_slot.overlaps_with_appointment_list?(date_appointments)
          time_slots << time_slot
        end

        iteration_time += (60 * @slot_time_in_min)
      end
    end

    time_slots
  end

  def working_hours_available_for_date?(date)
    not get_working_hours(date).empty?
  end

  def get_working_hours(date)
    @working_hours_per_day ||= @doctor.working_hours_per_day

    @working_hours_per_day[TimeUtils.day_name(date)]
  end

  def get_appointments(date)
    @appointments_per_date ||= @doctor.appointments_per_date(@start_date, @end_date)

    @appointments_per_date[date.to_s]
  end
end