require "csv"
require "time"





contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|
  registration_date = row[:regdate]

  reg = Time.strptime(registration_date, "%m/%d/%y %k").hour

  puts reg
end