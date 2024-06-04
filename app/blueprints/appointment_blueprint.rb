class AppointmentBlueprint < Blueprinter::Base
  identifier :id

  fields :doctor_id, :patient_id

  field :start_time do |appointment, _options|
    appointment.start_time.iso8601
  end
end