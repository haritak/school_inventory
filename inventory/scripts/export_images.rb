#!../bin/rails runner


puts "This script will export all images from db into item_images/ folder."
puts "Press enter to start."
gets

items = Item.all
items.each do |i|
  filename = sprintf "%010d", i.id
  filename = "#{i.id}"
  if i.photo_data
    puts "#{filename}.photo.1.jpg"
  end
  if i.photo_data2
    puts "#{filename}.photo.2.jpg"
  end
  if i.invoice
    puts "invoice"
    puts "#{filename}.invoice.1.jpg"
  end
end


