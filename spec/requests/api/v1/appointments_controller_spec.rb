require 'rails_helper'

RSpec.describe 'Appointment',  type: :request do
  let!(:doctor)       { create(:doctor, time_slot_per_client_in_min: 60) }
  let!(:patient)      { create(:patient) }
  let!(:working_hour) { create(:working_hour, day_of_week: 'monday', start_time: '10:00', end_time: '18:00', doctor: doctor) }

  let!(:valid_attributes) { {
    doctor_id: doctor.id,
    patient_id: patient.id,
    start_time: DateTime.new(2024,1,1,15) # Monday (15:00 hs)
  } }

  describe 'Create' do
    it 'creates a new appointment' do
      expect(Appointment.last).to eq(nil)

      post(
        api_v1_appointments_path,
        headers: { 'Content-Type': 'application/json' },
        params: valid_attributes.to_json
      )

      #**************************** Controller Validation **************************
      expect(response).to have_http_status(:created)
      expect(response.parsed_body).to match(
        {
          'id' => Integer,
          'start_time' => "2024-01-01T15:00:00Z",
          'doctor_id' => doctor.id,
          'patient_id' => patient.id
        }
      )

      #***************************** DB Validation *********************************
      appointment = Appointment.last
      expect(appointment.start_time).to eq(valid_attributes[:start_time])
      expect(appointment.end_time).to   eq(valid_attributes[:start_time] + doctor.time_slot_per_client_in_min.minutes)
      expect(appointment.doctor_id).to  eq(doctor.id)
      expect(appointment.patient_id).to eq(patient.id)
    end

    # it "fails with invalid params" do
    #   #**************** start_time is not within doctor's working hours *******************
    # end
  end

  describe 'Update' do
    it 'updates an appointment' do
      appointment = Appointment.create valid_attributes
      expect(appointment.start_time.day).to eq(1)
      expect(appointment.start_time.hour).to eq(15)

      body = {
        doctor_id:  doctor.id,
        patient_id: patient.id,
        start_time: DateTime.new(2024, 1, 8, 16) # Monday (16:00 hs)
      }

      put(
        api_v1_appointment_path(appointment),
        headers: { 'Content-Type': 'application/json' },
        params: body.to_json
      )

      #**************************** Controller Validation **************************
      expect(response).to have_http_status(:ok)
      expect(response.parsed_body).to match({
        'id' => appointment.id,
        'start_time' => "2024-01-08T16:00:00Z",
        'doctor_id' => doctor.id,
        'patient_id' => patient.id}
      )

      #***************************** DB Validation *********************************
      appointment.reload
      expect(appointment.start_time.day).to   eq(8)
      expect(appointment.end_time.day).to     eq(8)

      expect(appointment.start_time.hour).to  eq(16)
      expect(appointment.end_time.hour).to    eq(17)
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