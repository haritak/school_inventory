#!../../bin/rails runner
#!/usr/bin/ruby
file = File.open( "20181108.onlyKTcodes.csv", "r")
file.each_line do |line|
  serial_no = line.strip
  serial_no.gsub!(/ΚΤ/,"KT") #substitute greek KT (from inventory report)  with english KT (in mysql)
  item = Item.find_by( serial: serial_no )
  serial_no.gsub!(/KT-/,"") #remove KT all together
  puts serial_no if not item 
end
file.close
