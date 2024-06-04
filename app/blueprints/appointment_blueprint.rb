class AppointmentBlueprint < Blueprinter::Base
  identifier :id

  fields :doctor_id, :patient_id, :start_time
end