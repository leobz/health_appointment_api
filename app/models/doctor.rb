class Doctor < ApplicationRecord
  has_many :working_hours
  has_many :appointments

  validates :first_name, :last_name, presence: true
end
