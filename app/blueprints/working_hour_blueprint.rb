class WorkingHourBlueprint < Blueprinter::Base
  identifier :day_of_week

  field :start_time do |working_hour, _opts|
    working_hour.start_time.strftime("%H:%M")
  end

  field :end_time do |working_hour, _opts|
    working_hour.end_time.strftime("%H:%M")
  end
end