require 'rails_helper'

RSpec.describe 'WorkingHoursController',  type: :request do
  it 'Index' do
    get api_v1_doctor_working_hours_path(doctor_id: 1)
    expect(response).to have_http_status(200)
    expect(response.parsed_body).to match(
      {
        'doctor_id' => '1',
        'working_hours' => [
          {'day' => 'monday', 'start_time' => '09:00', 'end_time' => '17:00'},
          {'day' => 'friday', 'start_time' => '09:00', 'end_time' => '17:00'}
        ]
      }
    )
  end
end
