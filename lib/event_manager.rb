require "csv"
require "google/apis/civicinfo_v2"
require "erb"



def clean_zipcode(zipcode)
  zipcode.to_s.rjust(5, "0")[0..4]
end

def legislators_by_zipcode(zip)
  civic_info = Google::Apis::CivicinfoV2::CivicInfoService.new
  civic_info.key = "AIzaSyClRzDqDh5MsXwnCWi0kOiiBivP6JsSyBw"

  begin
    civic_info.representative_info_by_address(
      address: zip,
      levels: "country",
      roles: ['legislatorUpperBody', 'legislatorLowerBody']
    ).officials
  rescue
    "You can find your rep by googling it"
  end
end

def save_thank_you_letter(id, form_letter)
  Dir.mkdir("output") unless Dir.exist?("output")
  filename = "output/thanks_#{id}.html"
  
  File.open(filename, "w") do |file|
    file.puts form_letter
  end
end

def hour_registered(time)
  Time.strptime(time, "%m/%d/%y %k").hour
end

def weekday_registered(time)
  day = Time.strptime(time, "%m/%d/%y %k").wday

  day = case day
  when 0 then "Sunday"
  when 1 then "Monday"
  when 2 then "Tuesday"
  when 3 then "Wednesday"
  when 4 then "Thursday"
  when 5 then "Friday"
  when 6 then "Saturday"
  end
  day
end
  

def time_of_day_registered(time)
  time_slots = {
    "Early Morning" => [1, 2, 3, 4, 5, 6, 7, 8],
    "Morning" => [9, 10, 11, 12],
    "Mid Day" => [13, 14, 15, 16],
    "Evening" => [17, 18, 19, 20],
    "Night" => [21, 22, 23, 0],
  }

  hour_count = []
  time_slots.map do |key, value|
    time.map {| n| hour_count.push(key) if value.any?(n) }
  end
  
  time_of_day = hour_count.reduce(Hash.new(0)) do |time_slot, count|
    time_slot[count] += 1
    time_slot
  end
  best_time_to_buy_ads(time_of_day)
end
  
def best_time_to_buy_ads(time)
  hour_count = []
  time.map do |key, value|
    hour_count.push(value)
  end
  print "\nBest time to buy ads are:\n"
  time.map do |key, value|
  puts key if value >= hour_count.sort[-2]
  end
end

def day_of_week_registered_count(day_array)
  days = day_array.reduce(Hash.new(0)) do |result, vote|
    result[vote] += 1
    result
  end
  best_day_to_buy_ads(days)
end

def best_day_to_buy_ads(day_array)
  day_count = []
  day_array.map do |key, value|
    day_count.push(value)
  end
  print "\nBest days to buy ads are:\n"
  day_array.map do |key, value|
  puts "#{key}" if value >= day_count.sort[-2]
  end
end

puts "Event Manager Initialized!"

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

template_letter = File.read("form_letter.erb")
erb_template = ERB.new template_letter
hours_registered = []
days_registered = []

contents.each do |row|
  id = row[0]
  name = row[:first_name]
  zipcode = clean_zipcode(row[:zipcode])
  registration_date = row[:regdate]

  legislators = legislators_by_zipcode(zipcode)
  form_letter = erb_template.result(binding)
  save_thank_you_letter(id, form_letter)
  
  hours_registered.push(hour_registered(registration_date))
  days_registered.push(weekday_registered(registration_date))
end

time_of_day_registered(hours_registered)
day_of_week_registered_count(days_registered)





