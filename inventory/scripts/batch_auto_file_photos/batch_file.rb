#!../../bin/rails runner
#
#
require 'thread'

class TempFile
  def initialize( f )
    @tempfile = f
  end

  def tempfile
    @tempfile
  end
end

DRY_RUN = false #do not file anything, leave the database intact

source_dir = "autofile"
done_dir = "completed"
failed_dir = "failed"

failed = [] # images that failed to file
ready = [] # images which can be filed
done = [] # images filed
not_found = [] #serials not found in database (will be created)

user = User.find_by( username: "haritak" )
if not user
  raise "Failed to find filing user."
end

puts "Filing under user #{user}"

count = 0
Dir[ "#{source_dir}/*" ].each do |filename|
  count+=1

  puts filename
  scanned_qr = `zbarimg #{filename}`

  if not scanned_qr or scanned_qr.strip == ""
    failed << [filename, "zbarimg failed to detect anything"]
    next
  end

  serial_no = ""
  scanned_qr.lines.each do |code|
    if code =~ /srv-1tee-moiron\.ira\.sch\.gr/

      code_parts = code.split('/')

      next if not code_parts or code_parts.length == 0
      next if not code_parts[ code_parts.length - 1]
      next if code_parts[ code_parts.length - 1].length == 0

      if serial_no != ""
        #two codes found, user has to input the code manually
        break
      end
      serial_no = code_parts[ code_parts.length - 1 ].strip
      if serial_no.include?("?") #there are parameters at the end
        serial_no = serial_no[0, serial_no.index("?")]
      end

      puts serial_no
    end
  end

  if serial_no != ""
    ready << [filename, serial_no]
  else
    failed << [filename, "no valid barcode detected"]
  end

end


ready.each do |item_line|
  filename = item_line[0]
  serial_no = item_line[1]
  puts "Working on #{filename} with serial no #{serial_no}"

  item = Item.find_by( serial: serial_no )
  if not item
    puts "Not found in database"
    not_found << [serial_no, "not found in database"]
    if not DRY_RUN
      item = Item.create( serial: serial_no, user: user)
    end
  end
  
  next if not item and DRY_RUN

  file = TempFile.new( filename )

	begin
	  if not item.primary_photo 
	    puts "Does not have a primary photo"
	    if not DRY_RUN 
	      item.uploaded_picture= file
	      puts "Primary photo added"
	      done << [filename, serial_no]
	      next
	    end
	  end
	  if not item.secondary_photo
	    puts "Does not have a secondary photo"
	    if not DRY_RUN
	      item.uploaded_second_picture= file
	      puts "Secondary photo added"
	      done << [filename, serial_no]
	      next
	    end
	  end
	  #
	  #Do not file invoice.
	  #Invoices have to be filed by hand.
	  #
	  #if not item.invoice_photo 
	  #
	    #puts "Does not have an invoice photo"
	    #if not DRY_RUN
	      #item.uploaded_invoice= file
	      #puts "Invoice photo added"
	      #done << [filename, serial_no]
	      #next
	    #end
	  #end
	rescue 
	puts "An error occured"
	failed << [filename, "Unexpected error"]
	end


end

File.open( "log.txt", "w" ) do |f|
  f.write("\nFailed\n")
  failed.each do |line|
    bline = sprintf "%20s, %s\n", line[0], line[1]
    f.write( bline )
  end
  
  f.write("\nReady\n")
  ready.each do |line|
    bline = sprintf "%20s, %s\n", line[0], line[1]
    f.write( bline )
  end

  f.write("\nNot found in database\n")
  not_found.each do |line|
    bline = sprintf "%20s, %s\n", line[0], line[1]
    f.write( bline )
  end

  f.write("\nCompleted\n")
  done.each do |line|
    bline = sprintf "%20s, %s\n", line[0], line[1]
    f.write( bline )
  end
end


