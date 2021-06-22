# frozen_string_literal: true

require 'active_support/all'
require_relative 'file_reader'
months_array = %w[Jan Feb March April May Jun Jul Aug Sep Oct Nov Dec]
module WeatherMan
  # class name Weather
  class Weather
    include FileReader
    attr_accessor :month_name, :max_temp, :max_temp_date, :min_temp, :min_temp_date, :mean_temp, :max_humidity,
                  :max_humid_date, :min_humidity, :min_humid_date, :mean_humidity, :days_in_a_month

    def initialize(month_name = '')
      @month_name = month_name
      @max_temp = 0
      @min_temp = 100
      @max_humidity = 0
      @max_temp_date = ''
      @min_temp_date = ''
      @max_humid_date = ''
    end

    def find_lowest_temp(min_temp, date)
      return nil unless (min_temp != '') && min_temp.to_i < @min_temp

      @min_temp = min_temp.to_i
      @min_temp_date = date
    end

    def find_highest_humidity(max_humidity, date)
      return nil unless (max_humidity != '') && max_humidity.to_i > @max_humidity

      @max_humidity = max_humidity.to_i
      @max_humid_date = date
    end

    def find_heighest_temp(max_temp, date)
      return nil unless (max_temp != '') && max_temp.to_i > @max_temp

      @max_temp = max_temp.to_i
      @max_temp_date = date
    end

    def print_weather
      puts "Highest: #{@max_temp}C on #{Time.zone.parse(@max_temp_date).strftime('%B %d')}" if max_temp_date != ''
      puts "Lowest: #{@min_temp}C on #{Time.zone.parse(@min_temp_date).strftime('%B %d')}" if min_temp_date != ''
      puts "Humid: #{@max_humidity}% on #{Time.zone.parse(@max_humid_date).strftime('%B %d')}" if max_humid_date != ''
    end

    def perform_main_logic(columns, month_weather)
      month_weather.find_heighest_temp(columns[1], columns[0])
      month_weather.find_lowest_temp(columns[3], columns[0])
      month_weather.find_highest_humidity(columns[7], columns[0])
      month_weather
    end

    def self.task1_calculations_for_each_month(month)
      month_weather = WeatherMan::Weather.new
      return nil unless month_weather.check_if_file_exist(month)

      lines = month_weather.read_file(month, ARGV[1])
      lines.each_with_index do |line, index|
        next if index.zero?

        columns = line.split(',')
        month_weather = month_weather.perform_main_logic(columns, month_weather)
      end
      month_weather
    end
  end
end

def task1(months_array)
  yearly_weather = WeatherMan::Weather.new
  months_array.each_with_index do |month, _key|
    weather = WeatherMan::Weather.task1_calculations_for_each_month(month)
    next if weather.nil?

    yearly_weather.find_heighest_temp(weather.max_temp, weather.max_temp_date)
    yearly_weather.find_lowest_temp(weather.min_temp, weather.min_temp_date)
    yearly_weather.find_highest_humidity(weather.max_humidity, weather.max_humid_date)
  end
  yearly_weather.print_weather
end
Time.zone = 'UTC'
task1(months_array)
