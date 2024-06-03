class WorkingHour < ApplicationRecord
  belongs_to :doctor

  validates :day, :start_time, :end_time, presence: true
  validates :day, uniqueness: { scope: :doctor_id }
end