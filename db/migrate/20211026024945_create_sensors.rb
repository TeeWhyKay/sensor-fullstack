class CreateSensors < ActiveRecord::Migration[6.0]
  def change
    create_table :sensors do |t|
      t.timestamp :timelog
      t.string :device_id
      t.string :type
      t.boolean :status

      t.timestamps
    end
  end
end
