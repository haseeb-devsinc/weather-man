# frozen_string_literal: true

require 'colorize'
require 'active_support/all'
require_relative 'file_reader'
months_array = %w[Jan Feb March April May Jun Jul Aug Sep Oct Nov Dec]
module WeatherMan
  # class name Weather
  class Weather
    include FileReader
    attr_accessor :month_name, :max_temp, :max_temp_date, :min_temp, :min_temp_date, :mean_temp, :max_humidity,
                  :max_humid_date, :min_humidity, :min_humid_date, :mean_humidity, :days_in_a_month

    def initialize(month_name, max_temp = 0, min_temp = 100, mean_humidity = 0)
      @month_name = month_name
      @max_temp = max_temp
      @min_temp = min_temp
      @mean_humidity = mean_humidity
      @max_temp_date = ''
      @min_temp_date = ''
      @max_humid_date = ''
    end

    def draw_bar_charts(month, year)
      return nil unless check_if_file_exist(month)

      read_file(month, year).each_with_index do |line, index|
        next if index.zero?

        columns = line.split(',')
        max_temp = columns[1]
        min_temp = columns[3]
        date = columns[0]

        draw_line(max_temp, :red, date)
        draw_line(min_temp, :blue, date)
      end
    end

    def draw_line(temp, color, date)
      return nil if temp == '' || date == '' || date.nil?

      temp = temp.to_i
      string = ''
      temp.times { string += '+' }
      case color
      when :red
        puts "#{Time.zone.parse(date).strftime('%d')} #{string.red} #{temp}"
      when :blue
        puts "#{Time.zone.parse(date).strftime('%d')} #{string.blue} #{temp}"
      end
    end
  end
end

def valid_arguments?
  month = ARGV[1].split('/')[1].to_i
  year = ARGV[1].split('/')[0].to_i
  return true unless month.zero? || year.zero?

  puts 'Year and month is not given or not in a format like -e 2005/6 file/path'
  false
end

def task3(months_array)
  return nil unless valid_arguments?

  month = ARGV[1].split('/')[1].to_i
  year = ARGV[1].split('/')[0]
  month = months_array[month - 1]
  weather_obj = WeatherMan::Weather.new(month)
  return puts 'Unable to locate file' unless weather_obj.check_if_file_exist(month)

  weather_obj.draw_bar_charts(month, year)
end

Time.zone = 'UTC'
task3(months_array)
