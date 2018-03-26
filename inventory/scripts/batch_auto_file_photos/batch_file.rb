#!/usr/bin/ruby
#
#
require 'thread'

DRY_RUN = true #do not file anything
LIMIT = 5000

source_dir = "autofile"
done_dir = "completed"
failed_dir = "failed"

failed = []
done = []

count = 0
Dir[ "#{source_dir}/*" ].each do |filename|
  count+=1
  break if count>LIMIT
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
    done << [filename, serial_no]
  else
    failed << [filename, "no valid barcode detected"]
  end

  if not DRY_RUN
  end

end

File.open( "log.txt", "w" ) do |f|
  all_arrays = done + failed
  all_arrays.each do |line|
    bline = sprintf "%20s, %s\n", line[0], line[1]
    f.write( bline )
  end
end

