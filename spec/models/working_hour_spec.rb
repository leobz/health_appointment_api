require 'rails_helper'

RSpec.describe 'WorkingHour' do
  context 'when a new working hour is overlapped with a previous one' do
    let!(:doctor) { create(:doctor) }

    it 'wont be created' do
      # Create initial working hour
      create(:working_hour, doctor: doctor, day_of_week: :monday, start_time: '10:00', end_time: '16:00')

      overlapping_times = [
        ['11:00', '15:00'],
        ['09:00', '17:00'],
        ['09:00', '15:00'],
        ['12:00', '17:00']
      ]

      overlapping_times.each do |start_time, end_time|
        expect {
          create(:working_hour, doctor: doctor, day_of_week: :monday, start_time: start_time, end_time: end_time)
        }.to raise_error(ActiveRecord::RecordInvalid, /Working hours cannot overlap with existing working hours/)
      end
    end
  end
end