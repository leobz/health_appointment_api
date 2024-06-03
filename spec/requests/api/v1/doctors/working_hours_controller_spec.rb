require 'rails_helper'

RSpec.describe 'WorkingHours',  type: :request do
  let!(:doctor)  {
    Doctor.create(
      full_name: 'John Doe',
      working_hours: [
        new_working_hour('monday', 9,17),
        new_working_hour('friday', 9,17)
      ]
    )
  }

  describe '#index' do
    it 'returns a list of working hours' do
      get api_v1_doctor_working_hours_path(doctor_id: doctor.id)

      expect(response).to have_http_status(200)
      expect(response.parsed_body).to match(
        [
          {'day' => 'monday', 'start_time' => '09:00', 'end_time' => '17:00'},
          {'day' => 'friday', 'start_time' => '09:00', 'end_time' => '17:00'}
        ]
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
