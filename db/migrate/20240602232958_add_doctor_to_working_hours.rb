class AddDoctorToWorkingHours < ActiveRecord::Migration[7.0]
  def change
    add_reference :working_hours, :doctor, foreign_key: true
    add_index :working_hours, [:doctor_id, :day_of_week]
  end
end
