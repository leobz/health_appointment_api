class TimeUtils
  # Creates a Time. Date fixed to 2000-01-01.
  def self.new_time(hour, minute = 0)
    Time.new(2000, 1, 1, hour, minute)
  end

  # Useful to compare times without dates. Example output: "17:11"
  def self.extract_time(datetime)
    datetime.strftime('%H:%M')
  end

  # Builds a Time object using the date from the 'datetime' and the hour and minute from the 'time'.
  def self.build_time(datetime, time)
    Time.new(datetime.year, datetime.month, datetime.day, time.hour, time.min)
  end

  # Returns the lowercase name of the day for the given datetime. (i.e.: "saturday")
  def self.day_name(datetime)
    datetime.strftime("%A").downcase
  end
end