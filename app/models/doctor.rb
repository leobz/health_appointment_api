class Doctor < ApplicationRecord
  has_many :working_hours
  has_many :appointments

  validates :full_name, presence: true
end
