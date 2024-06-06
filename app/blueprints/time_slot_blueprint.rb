class TimeSlotBlueprint < Blueprinter::Base
  identifier :start_time

  field :start_time do |time_slot, _options|
    time_slot.start_time.iso8601
  end
end