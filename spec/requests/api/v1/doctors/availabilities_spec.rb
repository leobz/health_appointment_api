require 'rails_helper'

RSpec.describe 'Availabilities',  type: :request do
  let!(:doctor)         { create(:doctor, time_slot_per_client_in_min: 60) }
  let!(:working_hour_1) { create(:working_hour, day_of_week: 'monday', start_time: '10:00', end_time: '12:00', doctor: doctor) }
  let!(:working_hour_2) { create(:working_hour, day_of_week: 'wednesday', start_time: '10:00', end_time: '12:00', doctor: doctor) }
  let!(:appointment)    { create(:appointment, start_time: DateTime.new(2024,06,03,10), doctor: doctor) }

  describe 'Index' do
    it 'returns a list of availabilities' do
      # Doctor's slot: 1 HOUR
      # Working Hours:
      #   Monday,     start_time = '10:00', end_time: = '12:00' -> (2 Slots: '10:00' and '11:00')
      #   Wednesday,  start_time = '10:00', end_time: = '12:00' -> (2 Slots: '10:00' and '11:00')
      # Appointment:
      #   Monday 3 Jun '10:00'

      # Date range: Monday 6 June to Monday 10 June
      # Expected Availabilities:
      #   Monday    3 June  (1 slot (1 reserved by appointment))
      #   Wednesday 5 June  (2 slots)
      #   Monday    10 June (2 slots)
      start_date = '2024-06-03' # 2024, June 3  -> Monday
      end_date   = '2024-06-10' # 2024, June 10 -> Monday (next week)

      get(api_v1_doctor_availabilities_path(doctor_id: doctor.id), params: { start_date: start_date, end_date: end_date })

      expect(response).to have_http_status(200)
      expect(response.parsed_body).to match([
        {
          'date' => '2024-06-03',
          'time_slots' => [
            { 'start_time' => '2024-06-03T11:00:00-03:00' }
          ]
        },
        {
          'date' => '2024-06-05',
          'time_slots' => [
            { 'start_time' => '2024-06-05T10:00:00-03:00' },
            { 'start_time' => '2024-06-05T11:00:00-03:00' }
          ]
        },
        {
          'date' => '2024-06-10',
          'time_slots' => [
            { 'start_time' => '2024-06-10T10:00:00-03:00' },
            { 'start_time' => '2024-06-10T11:00:00-03:00' }
          ]
        }
      ])
    end
  end
end