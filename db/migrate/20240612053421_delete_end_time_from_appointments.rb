class DeleteEndTimeFromAppointments < ActiveRecord::Migration[7.0]
  def change
    remove_column :appointments, :end_time
  end
end
