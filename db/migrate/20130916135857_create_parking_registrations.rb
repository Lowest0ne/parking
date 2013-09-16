class CreateParkingRegistrations < ActiveRecord::Migration
  def change
    create_table :parking_registrations do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.integer :spot_number
      t.date :parked_on

      t.timestamps
    end
  end
end
