class SensorsController < ApplicationController
  def main
  end

  def topbydate
    # use scope? the query directly returns a hash...
    date = Date.parse(params[:specified_date])
    # returns a hash of occurences { device_id: 8, device_id2: 9 ...}
    top_10_sensor_freq_date = top_sensors_on_date(date)
    date -= 7.day
    # For each device id, find the occurences last week, and get the frequency.
    # Iterate over each device id and perform query to get frequency.
    top_10_sensor_last_week = top_sensors_freq_last_week(top_10_sensor_freq_date.keys, date)
    @sensors = percentage_change(top_10_sensor_freq_date, top_10_sensor_last_week)
  end

  def sensors_last_30_days
    device_type = params[:device_type]
    status = params[:status]
    end_date = Date.today
    start_date = Date.today - 20.day
    # sql = "Select *, sensors.timelog::date, count(*) from sensors
    # WHERE status = true
    # AND device_type ='gateway'
    # AND timelog <= '2017-05-08 00:00'
    # AND timelog >= '2017-05-01 00:00'
    # group by 1
    # order by 1"
    @sensor_report = Sensor.where(device_type: device_type, status: status, timelog: (start_date.beginning_of_day..end_date.end_of_day)).group("#{Sensor.table_name}.timelog::date").count
  end

  private

  def top_sensors_on_date(date)
    Sensor.where(timelog: (date.beginning_of_day..date.end_of_day))
          .group('device_id')
          .order('count_device_id desc')
          .limit(10)
          .count('device_id')
  end

  def top_sensors_freq_last_week(device_id_arr, date)
    res = {}
    device_id_arr.each do |device_id|
      res[device_id] = Sensor.where(device_id: device_id,
                                    timelog: (date.beginning_of_day..date.end_of_day)).count
    end
    res
  end

  def percentage_change(freq_today, freq_last_week)
    sensors = {}
    # go through each device id, check if last week value exists
    # if value exists, calculate % change
    # if it does not exist, + 100% change
    freq_today.each do |device_id, new_freq|
      if freq_last_week.key?(device_id) && freq_last_week[device_id] != 0
        diff = new_freq - freq_last_week[device_id]
        sensors[device_id] = diff.fdiv(freq_last_week[device_id]).truncate(4) * 100
      else
        sensors[device_id] = 100.00
      end
    end
    sensors
  end
end
