#run this script with:
#bin/rails runner path/to/filename.rb
#
#

username = "haritak" 
filename = "25_6_2015.inventory.txt"

user = User.find_by(username: "haritak")

if not user
  puts "User #{username} was not found in database"
end

puts "This script will add to your database the codes and the descriptions found in #{filename}."
puts "All changes to the database will be filled under #{username}."
puts "Press enter to continue"
gets

File.new(filename).each do |line|
  if line =~ /(KT-[0-9]+)\s+(.*)/
    code = $1.strip
    description = $2.strip
    next if code=='' or description==''


    begin
      Item.create( serial: code, description: description, user_id: user.id )
      puts "#{code}: #{description} under user #{user.id} - #{user.username}"
    rescue ActiveRecord::RecordNotUnique => e
      puts "Serial #{code} already exists"
    end
  end
end

puts "All done"

