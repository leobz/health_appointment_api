require 'rails_helper'

RSpec.describe 'WorkingHours',  type: :request do
  let!(:doctor)         { create(:doctor) }
  let!(:working_hour1)  { create(:working_hour, day_of_week: :monday, doctor: doctor) }
  let!(:working_hour2)  { create(:working_hour, day_of_week: :friday, doctor: doctor) }

  describe 'Index' do
    it 'returns a list of working hours' do
      get api_v1_doctor_working_hours_path(doctor_id: doctor.id)

      expect(response).to have_http_status(200)
      expect(response.parsed_body).to match(
        [
          {'id' => Integer, 'day_of_week' => 'monday', 'start_time' => '09:00', 'end_time' => '17:00'},
          {'id' => Integer, 'day_of_week' => 'friday', 'start_time' => '09:00', 'end_time' => '17:00'}
        ]
      )
    end
  end

  describe "Show" do
    it 'returns the working_hour if record exists' do
      get api_v1_doctor_working_hour_path(doctor_id: doctor.id, id: working_hour1.id)

      expect(response).to have_http_status(200)
      expect(json).not_to be_empty
      expect(json['id']).to eq(working_hour1.id)
    end

    it 'returns status code 404 if record does not exist' do
      invalid_working_hour_id = 100
      get api_v1_doctor_working_hour_path(doctor_id: doctor.id, id: invalid_working_hour_id)

      expect(response).to have_http_status(404)
      expect(response.body).to match(/Couldn't find WorkingHour/)
    end
  end

  describe "Create" do
    let(:valid_attributes) { { doctor_id: doctor.id, day_of_week: "saturday", start_time: "09:00", end_time: "10:00" } }

    it 'Valid Request: creates a working_hour' do
      post api_v1_doctor_working_hours_path(doctor_id: doctor.id), params: valid_attributes

      expect(response).to have_http_status(201)
      expect(json['day_of_week']).to eq('saturday')
      expect(json['doctor_id']).to eq(doctor.id)
      expect(json['start_time']).to match('09:00:00')
      expect(json['end_time']).to match('10:00:00')
    end

    it 'Invalid Request: returns status code 422' do
      post api_v1_doctor_working_hours_path(doctor_id: doctor.id), params: { doctor_id: 'John' }

      expect(response).to have_http_status(422)
    end
  end

  describe "Update" do
    let(:valid_attributes) { { start_time: '05:00' } }

    it 'updates the record' do
      put api_v1_doctor_working_hour_path(doctor_id: doctor.id, id: working_hour1.id), params: valid_attributes

      expect(response).to have_http_status(200)
      expect(json['start_time']).to match('05:00')
    end
  end

  describe "Delete" do
    it 'returns status code 204' do
      delete api_v1_doctor_working_hour_path(doctor_id: doctor.id, id: working_hour1.id)

      expect(response).to have_http_status(204)
    end
  end
end

def json
  JSON.parse(response.body)
end