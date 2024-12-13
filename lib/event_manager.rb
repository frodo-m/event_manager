# frozen_string_literal: true

require 'csv'
require 'google-apis-civicinfo_v2'
require 'erb'

def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, '0')[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = File.read('secret.key').strip

  begin
    civic_info.representative_info_by_address(
      address: zip, levels: 'country', roles: %w[legislatorUpperBody legislatorLowerBody]
    ).officials
  rescue StandardError
    'You can find your representatives by visiting www.commoncause.org/take-action/find-elected-officials'
  end
end

def save_thank_you_letter(id, form_letter)
  FileUtils.mkdir_p('output')

  filename = "output/thanks_#{id}.html"

  File.open(filename, 'w') do |file|
    file.puts form_letter
  end
end

def clean_phone_numbers(number)
  number.to_s.gsub(/[^\d]/, '')
end

def format_number(number)
  number.gsub(/(\d{3})(\d{3})(\d{4})/, '(\1) \2-\3')
end

def check_phone_numbers(number)
  clean_number = clean_phone_numbers(number)

  if clean_number.length == 10
    format_number(clean_number)
  else
    clean_number[0] == '1' ? format_number(clean_number[1..]) : 'BAD'
  end
end

def count_registration_hours(date)
  reg_hours = Hash.new(0)
  date.each do |row|
    reg_hour = Time.strptime(row[:regdate], '%m/%d/%y %k:%M').hour
    reg_hours[reg_hour] += 1
  end
  reg_hours
end

def count_registration_days(date)
  reg_days = Hash.new(0)
  date.each do |row|
    reg_day = Time.strptime(row[:regdate], '%m/%d/%y %k:%M').day
    reg_days[reg_day] += 1
  end
  reg_days
end

puts 'EventManager initialized.'

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read('form_letter.erb')
erb_template = ERB.new template_letter

contents.each do |row|
  id = row[0]
  name = "#{row[:first_name]} #{row[:last_name]}"
  zipcode = clean_zipcode row[:zipcode]
  phone_numbers = check_phone_numbers row[:homephone]

  contents.rewind
  reg_hour = count_registration_hours(contents)
  reg_hour.each do |hour, count|
    p "Hour #{hour}: #{count} registration(s)"
  end

  contents.rewind
  reg_days = count_registration_days(contents)
  reg_days.each do |day, count|
    puts "Day #{day}: #{count} registration(s)"
  end

  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)

  save_thank_you_letter(id, form_letter)
end
