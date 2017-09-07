#!../bin/rails runner

puts "This script will mark each item_photo as invoice, "
puts "primary or secondary based on its description."
puts "Press enter to start."
gets

item_photos = ItemPhoto.all

item_photos.each do |ip|
  if ip.description
    if ip.description.include? "photo"
      if ip.priority == 1
        ip.update( type: "PrimaryPhoto" )
        puts "detected primary photo"
      elsif ip.priority == 2
        ip.update( type: "SecondaryPhoto")
        puts "detected secondary photo"
      end
    elsif ip.description.include? "invoice"
      ip.update( type: "InvoicePhoto" )
      puts "detected invoice photo"
    end

    ip.save
  end
end

puts "Done"



