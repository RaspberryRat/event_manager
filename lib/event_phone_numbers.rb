require "csv"
require "pry-byebug"


def clean_phone_numbers(phone_num)
  to_remove = {
    "-" => "",
    " " => "",
    "(" => "",
    ")" => "",
    "." => "",
  }
  phone_num = phone_num.gsub(/[- ().]/, to_remove)

  if phone_num.length == 10
    phone_num.insert(3, "-")
    phone_num.insert(7, "-")
  elsif phone_num.length == 11 && phone_num[0] == "1"
      phone_num = phone_num[1..]
  else
    phone_num = ""
  end
end

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|

  name  = row[:first_name]
  phone_num = clean_phone_numbers(row[:homephone])

  


  puts "#{name}'s number is #{phone_num}"
end