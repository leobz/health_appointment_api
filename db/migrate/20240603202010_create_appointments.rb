class CreateAppointments < ActiveRecord::Migration[7.0]
  def change
    create_table :appointments do |t|
      t.datetime :start_time, null: false

      t.timestamps
    end

    add_reference :appointments, :doctor, foreign_key: true
    add_reference :appointments, :patient, foreign_key: true
  end
end
