# frozen_string_literal: true

require 'time'
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

    def create_obj(month, columns)
      Weather.new(month, columns[1] == '' ? columns[1] : columns[1].to_i,
                  columns[3] == '' ? columns[3] : columns[3].to_i,
                  columns[8] == '' ? columns[8] : columns[8].to_i)
    end

    def populate_data(month, year)
      weather_array = Array[]
      read_file(month, year).each_with_index do |line, index|
        next if index.zero?

        columns = line.split(',')
        weather = create_obj(month, columns)
        weather_array.push(weather)
      end
      weather_array
    end

    def find_heighest_average_temp(weather_array)
      total_sum = 0
      count = 0
      weather_array.each do |value|
        if value.max_temp != ''
          total_sum += value.max_temp.to_i
          count += 1
        end
      end
      count <= 1 ? total_sum : total_sum / (count + 1)
    end

    def find_lowest_average_temp(weather_array)
      total_sum = 0
      count = 0
      weather_array.each do |value|
        if value.min_temp != ''
          total_sum += value.min_temp.to_i
          count += 1
        end
      end
      count <= 1 ? total_sum : total_sum / (count + 1)
    end

    def find_average_humidity(weather_array)
      total_sum, count = 0, 0
      weather_array.each do |value|
        if value.mean_humidity != ''
          total_sum += value.mean_humidity.to_i
          count += 1
        end
      end
      count <= 1 ? total_sum : total_sum / (count + 1)
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

def print_weather(weather_array)
  return nil unless weather_array.length.positive?

  weather_obj = WeatherMan::Weather.new('')
  puts "Highest Average : #{weather_obj.find_heighest_average_temp(weather_array)}C"
  puts "Lowest Average : #{weather_obj.find_lowest_average_temp(weather_array)}C"
  puts "Average Humidity : #{weather_obj.find_average_humidity(weather_array)}%"
end

def task2(months_array)
  return nil unless valid_arguments?

  year = ARGV[1].split('/')[0]
  month = months_array[ARGV[1].split('/')[1].to_i - 1]
  weather_obj = WeatherMan::Weather.new(month)
  return puts 'Unable to locate file' unless weather_obj.check_if_file_exist(month)

  weather_array = weather_obj.populate_data(month, year)
  print_weather(weather_array)
end

task2(months_array)
