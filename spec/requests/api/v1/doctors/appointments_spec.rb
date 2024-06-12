require 'rails_helper'

RSpec.describe "Doctor Appointments", type: :request do
  let!(:start_time)   { DateTime.new(2024,1,1,10) } # Monday (10:00 hs))
  let!(:doctor)       { create(:doctor, working_hours: [build(:working_hour, start_time: "10:00", end_time: "12:00")]) }
  let!(:appointments) { create_list(:appointment, 3, doctor: doctor, start_time: start_time)}

  describe "Index" do
    it "returns appointments of the doctor" do
      get api_v1_doctor_appointments_path(doctor_id: doctor.id)

      expect(response).to have_http_status(200)
      expect(response.parsed_body.size).to eq(3)
    end
  end
end
