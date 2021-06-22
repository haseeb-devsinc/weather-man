# frozen_string_literal: true

# Module for file reading
module FileReader
  def read_file(month, year)
    lines = File.readlines("#{ARGV[2]}/#{ARGV[2]}_#{year}_#{month}.txt")
    lines = lines[1..lines.length] if ARGV[2].include?('lahore')
    lines
  end

  def check_if_file_exist(month)
    ARGV[1] = ARGV[1].split('/')[0]
    File.exist?("#{ARGV[2]}/#{ARGV[2]}_#{ARGV[1]}_#{month}.txt")
  end
end
