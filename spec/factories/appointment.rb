FactoryBot.define do
  factory :appointment do
    start_time  { DateTime.new(2024, 1, 1, 9, 0, 0) }
    patient     { create(:patient) }
  end
end