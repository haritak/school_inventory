#!../bin/rails runner

dirname = ARGV[0]


puts "Please supply a directory name." if not dirname

puts "This script will import the base filename of each file under #{dirname}"
puts "Press enter to start."
$stdin.gets

item_filenames = {}

directory = Dir.new( dirname )
puts "Checking contents of #{directory}"
directory.entries.each do | entry |

  full_path = File.join( directory.path, entry )
  
  next if File.directory? full_path

  if not File.readable? full_path
    puts "Warning: #{full_path} is not readable"
    next
  end

  parts = entry.split( "." )
  item_id = -1
  type = "none"
  type_no = -1
  begin
    item_id = parts[0].to_i
    type = parts[1]
    type_no = parts[2].to_i
  rescue => e
    puts "Warning: #{full_path} does not comply with filename spec."
    next
  end

  item_filenames[ full_path ] = [ item_id, type, type_no ]
end

puts "Checking completed."
puts "Hit enter to show which filename will be imported."
$stdin.gets

item_filenames.each do | full_path, data |
  basefilename = File.basename full_path

  puts "Will import #{basefilename} as #{data[1]}-#{data[2]} to item #{data[0]}"
end

puts "Hit enter to start importing"
$stdin.gets

item_filenames.each do | full_path, data |
  basefilename = File.basename full_path

  begin
    item_photo = ItemPhoto.create( item_id: data[0], 
                                  filename: basefilename,
                                  priority: data[2],
                                  description: data[1] )
    item_photo.save
  rescue ActiveRecord::RecordNotUnique => e
    puts "#{basefilename} already filled."
  end
end

puts "Done"








