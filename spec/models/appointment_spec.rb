require 'rails_helper'

RSpec.describe 'Appointment' do
  context 'validations' do
    let!(:doctor) { create(:doctor) }
    let!(:patient) { create(:patient) }

    it "is not valid if start_time is out of doctor's working hours" do
      # Create Working Hour: Monday (10 AM-11 AM)
      create(:working_hour, day_of_week: :monday, start_time: '10:00', end_time: '11:00', doctor: doctor)

      #************************** Invalid day ***********************
      invalid_date_time = DateTime.new(2024, 6 , 7, 10, 0, 0) # June 7, 2024 is a Friday
      expect(invalid_date_time.monday?).to be(false)

      invalid_appointment = Appointment.new(start_time: invalid_date_time, doctor: doctor, patient: patient)
      expect(invalid_appointment).not_to be_valid
      expect(invalid_appointment.errors[:start_time]).to include('must be within the doctor\'s working hours')
    end
  end
end