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
          {'day_of_week' => 'monday', 'start_time' => '09:00', 'end_time' => '17:00'},
          {'day_of_week' => 'friday', 'start_time' => '09:00', 'end_time' => '17:00'}
        ]
      )
    end
  end
end