class SensorsController < ApplicationController
  def main
  end

  def topbydate
    date = Date.parse(params[:specified_date])
    #returns a hash of occurences
    top_10_sensor_freq_date = Sensor.where(timelog: (date.beginning_of_day..date.end_of_day))
                                    .group('device_id')
                                    .order('count_device_id desc')
                                    .limit(10)
                                    .count('device_id')
    date -= 7.day
    top_10_sensor_freq_last_week = Sensor.where(timelog: (date.beginning_of_day..date.end_of_day))
                                         .group('device_id')
                                         .order('count_device_id desc')
                                         .limit(10)
                                         .count('device_id')
    @sensors = {}
    top_10_sensor_freq_date.each do |device_id, new_freq|
      if top_10_sensor_freq_last_week.key?(device_id) && top_10_sensor_freq_date[device_id]
        diff = new_freq - top_10_sensor_freq_last_week[device_id]
        @sensors[:device_id] = diff.fdiv(top_10_sensor_freq_last_week[device_id]).truncate(4) * 100
      else
        @sensors[:device_id] = 100.00
      end
    end

    respond_to do |format|
      format.json
    end
  end



end
