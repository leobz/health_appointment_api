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
    time_slots = []

    @working_hours.each do |working_hour|
      iteration_time = working_hour.start_time

      while iteration_time < working_hour.end_time
        time_slot = TimeSlot.new(TimeUtils.build_time(date, iteration_time), @slot_duration_in_min)

        unless time_slot.overlaps_with_appointment_list?(@appointments)
          time_slots << time_slot
        end

        iteration_time += (60 * @slot_duration_in_min)
      end
    end

    time_slots
  end
end