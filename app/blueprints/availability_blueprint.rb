class AvailabilityBlueprint < Blueprinter::Base
  identifier :date

  association :time_slots, blueprint: TimeSlotBlueprint
end