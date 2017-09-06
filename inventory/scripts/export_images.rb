#!../bin/rails runner


puts "This script will export all images from db into item_images/ folder."
puts "Press enter to start."
gets

items = Item.all
items.each do |i|
  FileUtils.mkdir "item_images" if not File.exist? "item_images"

  filename_base = "item_images/#{i.id}"
  if i.photo_data
    filename = "#{filename_base}.photo.1.jpg"
    puts "Exporting into #{filename}"
    File.open( filename, "wb" ) do |file|
      file.write i.photo_data
    end
  end
  if i.photo_data2
    filename = "#{filename_base}.photo.2.jpg"
    puts "Exporting into #{filename}"
    File.open( filename, "wb" ) do |file|
      file.write i.photo_data2
    end
  end
  if i.invoice
    filename = "#{filename_base}.invoice.1.jpg"
    puts "Exporting into #{filename}"
    File.open( filename, "wb" ) do |file|
      file.write i.invoice
    end
  end
end


