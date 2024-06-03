class AddDoctorToWorkingHours < ActiveRecord::Migration[7.0]
  def change
    add_reference :working_hours, :doctor, foreign_key: true
  end
end
