FactoryBot.define do
  factory :appointment do
    start_time  { DateTime.new(2024, 1, 1, 9, 0, 0) }
    end_time    { start_time + doctor.time_slot_per_client_in_min.minutes }
    patient     { create(:patient) }
  end
end