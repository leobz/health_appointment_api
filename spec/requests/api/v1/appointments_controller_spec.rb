require 'rails_helper'

RSpec.describe 'Appointment',  type: :request do
  let!(:doctor)  { create(:doctor) }
  let!(:patient) { create(:patient) }
  let!(:valid_attributes) { {
    doctor_id: doctor.id,
    patient_id: patient.id,
    start_time: DateTime.new(2024,1,1,15)
  } }

  describe 'Create' do
    it 'creates a new appointment' do
      expect {
        post(
          api_v1_appointments_path,
          headers: { 'Content-Type': 'application/json' },
          params: valid_attributes.to_json
        )
      }.to change(Appointment, :count).by(1)

      #***************************** DB Validation *********************************
      appointment = Appointment.last
      expect(appointment.start_time).to eq(valid_attributes[:start_time])
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

  describe 'Update' do
    let!(:doctor_2) { create(:doctor) }
    let!(:patient_2) { create(:patient) }

    it 'updates an appointment' do
      appointment = Appointment.create valid_attributes

      body = {
        doctor_id:  doctor_2.id,
        patient_id: patient_2.id,
        start_time: DateTime.new(2024,1,2,12)
      }

      put(
        api_v1_appointment_path(appointment),
        headers: { 'Content-Type': 'application/json' },
        params: body.to_json
      )

      #***************************** DB Validation *********************************
      appointment.reload
      expect(appointment.start_time).to eq(body[:start_time])
      expect(appointment.doctor_id).to  eq(doctor_2.id)
      expect(appointment.patient_id).to eq(patient_2.id)

      #**************************** Controller Validation **************************
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to match({
        'id' => appointment.id,
        'start_time' => "2024-01-02T12:00:00Z",
        'doctor_id' => doctor_2.id,
        'patient_id' => patient_2.id}
      )
    end
  end

  describe 'Delete' do
    it 'deletes an appointment' do
      appointment = Appointment.create valid_attributes
      expect { delete api_v1_appointment_path(appointment) }.to change(Appointment, :count).by(-1)

      #***************************** DB Validation *********************************
      expect(Appointment.last).to eq(nil)

      #**************************** Controller Validation **************************
      expect(response).to have_http_status(:no_content)
    end
  end
end
