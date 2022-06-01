require "csv"
require "pry-byebug"

contents = CSV.open(
  'event_attendees.csv',
  headers: true,
  header_converters: :symbol
)

contents.each do |row|

  name  = row[:first_name]
  phone_num = row[:homephone]

  phone_num = phone_num.gsub("-", "")
  phone_num = phone_num.gsub(" ", "")
  phone_num = phone_num.gsub("(", "")
  phone_num = phone_num.gsub(")", "")
  phone_num = phone_num.gsub(".", "")

  unless phone_num.length == 10
    if phone_num.length == 11 && phone_num[0] == "1"
      phone_num = phone_num[1..]
    else
      phone_num = ""
    end
  end

  if phone_num.length == 10
    phone_num.insert(3, "-")
    phone_num.insert(7, "-")
  end


  puts "#{name}'s number is #{phone_num}"
end