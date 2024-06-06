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
    appointments_per_date = @doctor.appointments_per_date(@start_date, @end_date)

    (@start_date..@end_date).each do |date|
      # Create Availabilities
      if working_hours_per_day.has_key?(date.strftime("%A").downcase)
        availability = Availability.new(date, [])

        # Create Timeslots
        working_hours_per_day[date.strftime("%A").downcase].each do |working_hour|
          time = working_hour.start_time

          while time < working_hour.end_time
            date_time = DateTime.new(date.year, date.month, date.day, time.hour, time.min)
            date_appointments = appointments_per_date[date.to_s]
            overlap_exists = date_appointments.any? do |appointment|
              slot_start_time = TimeUtils.extract_time(Time.new(date.year, date.month, date.day, time.hour, time.min))
              slot_end_time = TimeUtils.extract_time(Time.new(date.year, date.month, date.day, time.hour, time.min) +(60 * @slot_time_in_min))

              ap_start_t = TimeUtils.extract_time(appointment.start_time)
              ap_end_t = TimeUtils.extract_time(appointment.start_time.to_time + (60 * @slot_time_in_min) )

              (slot_start_time...slot_end_time).overlaps?(ap_start_t...ap_end_t)
            end

            availability.time_slots << TimeSlot.new(date_time) unless overlap_exists

            time = time + (60 * @slot_time_in_min)
          end
        end

        availabilities << availability
      end
    end

    availabilities
  end
end