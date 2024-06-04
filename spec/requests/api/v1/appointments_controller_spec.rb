require 'rails_helper'

RSpec.describe 'Appointment',  type: :request do
  let!(:doctor)  {
    Doctor.create(
      first_name: 'John',
      last_name: 'Doe',
      working_hours: [
        new_working_hour('monday', 9,17),
        new_working_hour('friday', 9,17)
      ]
    )
  }

  let!(:patient) { Patient.create(first_name: 'John', last_name: 'Smith') }

  describe 'Create' do
    it 'creates a new appointment' do
      body = {
        patient_id: patient.id,
        doctor_id: doctor.id,
        start_time: Time.zone.local(2024, 1, 1, 15, 0, 0)
      }

      expect {
        post(
          api_v1_appointments_path,
          headers: { 'Content-Type': 'application/json' },
          params: body.to_json
        )
      }.to change(Appointment, :count).by(1)

      #***************************** DB Validation *********************************
      appointment = Appointment.last
      expect(appointment.start_time).to eq(body[:start_time])
      expect(appointment.doctor_id).to  eq(doctor.id)
      expect(appointment.patient_id).to eq(patient.id)

      #**************************** Controller Validation **************************
      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to match(
          {
            'id' => appointment.id,
            'start_time' => "2024-01-01T15:00:00Z",
            'doctor_id' => doctor.id,
            'patient_id' => patient.id}
      )
    end
  end
end

# ***************+  Helper Methods  ******************#

def new_working_hour(day, start_hour, end_hour)
  WorkingHour.new(
    day: day,
    start_time: Time.zone.local(2000, 1, 1, start_hour, 0, 0),
    end_time: Time.zone.local(2000, 1, 1, end_hour, 0, 0)
  )
end
