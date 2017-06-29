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

unmatched_codes = {}
File.new(filename).each do |line|
  if line =~ /(KT-[0-9]+)\s+(.*)/
    code = $1.strip
    description = $2.strip
    next if code==''
    
    if description==''
      puts code
      unmatched_codes[ code ] = ""
      next
    end


    begin
      Item.create( serial: code, description: description, user_id: user.id )
      puts "#{code}: #{description} under user #{user.id} - #{user.username}"
    rescue ActiveRecord::RecordNotUnique => e
      puts "Serial #{code} already exists"
    end
  end
end

start=-1
code = ""
File.new(filename).each_with_index do |line,i|
  puts "#{i}:#{line}" if start>0
  if line =~ /(KT-[0-9]+)\s+(.*)/
    start = -1
    code = $1.strip
    if unmatched_codes.include?( code )
      start = 1
      puts "Looking for description of #{code}"
    end
  elsif start>0 and start<10
    start+=1
    line = line.strip
    if line!='' and line!='1' and (not line.start_with?("Κτημ")) and (not line.start_with?("Περιγ"))
      unmatched_codes[ code ] = line
      puts "Found description of #{code} to be #{line}"
      start=-1
    end
  end
end

unmatched_codes.each do |c, d| 
  if d.strip != ''
    puts "Matched code #{c} with #{d}"
    begin
      Item.create( serial: c, description: d, user_id: user.id )
      puts "#{c}: #{d} under user #{user.id} - #{user.username}"
    rescue ActiveRecord::RecordNotUnique => e
      puts "Serial #{c} already exists"
    end

  else
    puts "UNMATCHED CODE #{c}"
  end
end

puts "All done"

