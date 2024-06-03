class Doctor < ApplicationRecord
  has_many :working_hours

  validates :full_name, presence: true
end
