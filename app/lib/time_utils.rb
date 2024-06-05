class TimeUtils
  # Creates a Time. Date fixed to 2000-01-01.
  def self.new_time(hour, minute = 0)
    Time.zone.local(2000, 1, 1, hour, minute)
  end

  # Useful to compare times without dates. Example output: "17:11"
  def self.extract_time(date_time)
    date_time.strftime('%H:%M')
  end
end