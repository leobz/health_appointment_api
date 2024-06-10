FactoryBot.define do
  factory :doctor do
    first_name { 'John' }
    last_name  { 'Doe'  }
    time_slot_per_client_in_min { 60 }
  end
end