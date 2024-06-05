require 'rails_helper'

RSpec.describe 'WorkingHour' do
  context 'validations' do
    let!(:doctor) { create(:doctor) }

    it 'is not valid if start_time is after end_time' do
      working_hour = build(:working_hour, doctor: doctor, start_time: '16:00', end_time: '10:00')

      expect(working_hour).not_to be_valid
      expect(working_hour.errors[:start_time]).to include('must be before end_time')
    end

    it 'is not valid if is overlapped' do
      # Create initial working hour
      create(:working_hour, doctor: doctor, day_of_week: :monday, start_time: '10:00', end_time: '16:00')

      overlapping_times = [
        ['11:00', '15:00'],
        ['09:00', '17:00'],
        ['09:00', '15:00'],
        ['12:00', '17:00']
      ]

      overlapping_times.each do |start_time, end_time|
        # Overlapping with the same doctor and day
        overlapping_working_hour = build(:working_hour, doctor: doctor, day_of_week: :monday, start_time: start_time, end_time: end_time)

        expect(overlapping_working_hour).not_to be_valid
        expect(overlapping_working_hour.errors[:base]).to include('Working hours cannot overlap with existing working hours')
      end
    end
  end
end