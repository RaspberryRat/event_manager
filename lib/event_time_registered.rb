require "csv"
require "time"
require "pry-byebug"




contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

hours_registered = []
contents.each do |row|
  registration_date = row[:regdate]

  hours_registered.push(Time.strptime(registration_date, "%m/%d/%y %k").hour)
end

puts hours_registered.detect { |n| hours_registered.count(n) > 1}

time_slots = {
  "early_morning" => [1, 2, 3, 4, 5, 6, 7, 8],
  "morning" => [9, 10, 11, 12],
  "mid_day" => [13, 14, 15, 16],
  "evening" => [17, 18, 19, 20],
  "night" => [21, 22, 23, 0],
}

hour_count = []
time_slots.map do |key, value|
  hours_registered.map {| n| hour_count.push(key) if value.any?(n) }
end

x = hour_count.reduce(Hash.new(0)) do |time_slot, count|
  time_slot[count] += 1
  time_slot
end


temp_array = []
x.map do |key, value|
  temp_array.push(value)
end
print "Best time to buy ads is:\n"
x.map do |k, v|
puts k if v >= temp_array.sort[-2]
end