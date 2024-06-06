class SlotManager
  Availability  = Struct.new(:date, :time_slots)
  TimeSlot      = Struct.new(:start_time)

  def initialize(doctor, start_date, end_date)
    @doctor = doctor
    @slot_time_in_min = doctor.time_slot_per_client_in_min
    @start_date = start_date
    @end_date = end_date
  end

  def get_availabilities
    availabilities = []
    working_hours_per_day =  @doctor.working_hours_per_day
    (@start_date..@end_date).each do |date|
      # Create Availabilities
      if working_hours_per_day.has_key?(date.strftime("%A").downcase)
        availability = Availability.new(date, [])

        # Create Timeslots
        working_hours_per_day[date.strftime("%A").downcase].each do |working_hour|
          time = working_hour.start_time

          while time < working_hour.end_time
            availability.time_slots << TimeSlot.new(DateTime.new(date.year, date.month, date.day, time.hour, time.min))
            time = time + (60 * @slot_time_in_min)
          end
        end

        availabilities << availability
      end
    end

    availabilities
  end
end