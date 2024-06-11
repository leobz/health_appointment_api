class Availability
  attr_accessor :date

  def initialize(slot_duration_in_min, date, appointments, working_hours)
    @date = date
    @appointments = appointments
    @working_hours = working_hours
    @slot_duration_in_min = slot_duration_in_min
  end

  def time_slots
    @time_slots ||= build_time_slots
  end

  private

  def build_time_slots
    @working_hours.flat_map { |working_hour|  build_time_slots_for_working_hour(working_hour)}
  end

  def build_time_slots_for_working_hour(working_hour)
    working_hour
      .to_times
      .each_with_object([]) do |time, time_slots|
        time_slot = build_time_slot(time)
        time_slots << time_slot if !time_slot.overlaps_with_appointment_list?(@appointments)
      end
  end

  def build_time_slot(time)
    start_time = TimeUtils.build_time(@date, time)
    end_time   = TimeUtils.build_time(@date, time + @slot_duration_in_min.minutes)

    TimeSlot.new(start_time, end_time)
  end
end