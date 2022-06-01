require "csv"
require "time"
require "pry-byebug"



def hour_registered(time)
  Time.strptime(time, "%m/%d/%y %k").hour
end

def time_of_day_registered(time)
  time_slots = {
    "early_morning" => [1, 2, 3, 4, 5, 6, 7, 8],
    "morning" => [9, 10, 11, 12],
    "mid_day" => [13, 14, 15, 16],
    "evening" => [17, 18, 19, 20],
    "night" => [21, 22, 23, 0],
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
  print "Best time to buy ads is:\n"
  time.map do |key, value|
  puts key if value >= hour_count.sort[-2]
  end
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)
# TODO find a way to now you empty array here
hours_registered = []
contents.each do |row|
  registration_date = row[:regdate]
  hours_registered.push(hour_registered(registration_date))
end
time_of_day_registered(hours_registered)
