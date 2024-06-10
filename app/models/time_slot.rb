class TimeSlot
  attr_accessor :start_time, :end_time
  def initialize(start_time, slot_duration_in_min)
    @start_time = start_time
    @end_time   = start_time + slot_duration_in_min * 60
    @slot_duration_in_min = slot_duration_in_min
  end

  def overlaps_with_appointment_list?(appointments)
    appointments.any? do |appointment|
      self.overlaps_with_appointment?(appointment)
    end
  end

  private

  def overlaps_with_appointment?(appointment)
    slot_time_range   = TimeUtils.extract_time(start_time)...TimeUtils.extract_time(end_time)
    appointment_range = TimeUtils.extract_time(appointment.start_time)...TimeUtils.extract_time(appointment.start_time + (60 * @slot_duration_in_min) )

    slot_time_range.overlaps?(appointment_range)
  end
end