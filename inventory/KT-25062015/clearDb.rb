#run this script with:
#bin/rails runner path/to/filename.rb
#
#

puts "This script will CLEAR your database of the greek codes"
puts "Press enter to continue"
gets

items = Item.all
items.each do |i|
  if i.serial =~ /ΚΤ.*/ #greek KT
    puts "Found a match"
    i.destroy
  end
end
