# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Sensor.destroy_all
require 'csv'

csv_options = { col_sep: ',', quote_char: '"', headers: :first_row }
filepath    = 'db/report.csv'

puts 'begin sensor data seeding'
CSV.foreach(filepath, csv_options) do |row|
  Sensor.create(timelog: row['timestamp'],
                device_id: row['id'],
                device_type: row['type'],
                status: row['status'] == 'online')
end
puts 'seeding sensor data completed'
