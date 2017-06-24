#run this script with:
#bin/rails runner path/to/filename.rb
#
#

username = "haritak" 
filename = "2017_06.ΚωδικοίΑιθουσών.txt"

user = User.find_by(username: "haritak")

if not user
  puts "User #{username} was not found in database"
end

puts "This script will add to your database the codes and the descriptions found in #{filename}."
puts "All changes to the database will be filled under #{username}."
puts "Press enter to continue"
gets

2.times do |t|
  puts "First pass, read the file only" if t==0
  puts "Second pass, read the file and store the data" if t==1
  File.open(filename, encoding:"bom|utf-8").each do |line|
    line = line.strip
    code = line[0, line.index(" ")].strip
    description = line[line.index(" "), line.length].strip

    puts ">#{code}< >#{description}<" if t==0

    if t==1
      begin
        Item.create( serial: code, description: description, user_id: user.id )
        puts "#{code}: #{description} under user #{user.id} - #{user.username}"
      rescue ActiveRecord::RecordNotUnique => e
        puts "Serial #{code} already exists"
      end
    end
  end
  if t==0
    puts "Press enter to continue"
    gets
  end
end

puts "All done"

