class RenameTypeToDeviceType < ActiveRecord::Migration[6.0]
  def change
    rename_column :sensors, :type, :device_type
  end
end
