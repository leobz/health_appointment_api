class TimeUtils
  # Creates a Time. year, month, and day are fixed to 2000-01-01.
  def self.new_time(hour, minute = 0)
    Time.zone.local(2000, 1, 1, hour, minute)
  end
end