class CreateDoctors < ActiveRecord::Migration[7.0]
  def change
    create_table :doctors do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.integer :time_slot_per_client_in_min

      t.timestamps
    end
  end
end
