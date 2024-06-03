class WorkingHourBlueprint < Blueprinter::Base
  identifier :id

  fields :day, :start_time, :end_time
end