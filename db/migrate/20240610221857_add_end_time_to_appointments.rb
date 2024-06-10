class AddEndTimeToAppointments < ActiveRecord::Migration[7.0]
  def change
    add_column :appointments, :end_time, :datetime, null: false
  end
end
