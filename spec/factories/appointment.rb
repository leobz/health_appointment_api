FactoryBot.define do
  factory :appointment do
    start_time  { DateTime.new(2024, 1, 1, 9, 0, 0) }
    patient     { create(:patient) }
    doctor      { create(:doctor, working_hours: [build(:working_hour, start_time: start_time, end_time: start_time + 60.minute)]) }
  end
end