FactoryBot.define do
  factory :working_hour do
    transient do
      start_hour { 9 }
      end_hour {17}
    end

    day_of_week { 1 }
    start_time  { Time.zone.local(2000, 1, 1, start_hour, 0, 0)  }
    end_time    { Time.zone.local(2000, 1, 1, end_hour, 0, 0)  }
  end
end