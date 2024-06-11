class TimeSlot
  attr_accessor :start_time, :end_time
  def initialize(start_time, end_time)
    @start_time = start_time
    @end_time   = end_time
  end

  def overlaps_with_appointment_list?(appointments)
    return false if appointments.nil?

    appointments.any? { |appointment| self.overlaps_with_appointment?(appointment) }
  end

  private

  def overlaps_with_appointment?(appointment)
    # TODO: Implement a range() method in TimeSlot and Appointment (see if it's possible to use an interface/module)
    slot_time_range   = TimeUtils.extract_time(start_time)...TimeUtils.extract_time(end_time)
    appointment_range = TimeUtils.extract_time(appointment.start_time)...TimeUtils.extract_time(appointment.end_time)

    slot_time_range.overlaps?(appointment_range)
  end
end