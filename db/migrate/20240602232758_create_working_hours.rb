class CreateWorkingHours < ActiveRecord::Migration[7.0]
  def change
    create_table :working_hours do |t|
      t.integer :day_of_week, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false

      t.timestamps
    end
  end
end
