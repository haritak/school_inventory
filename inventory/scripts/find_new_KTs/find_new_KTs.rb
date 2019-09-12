#!../../bin/rails runner
#!/usr/bin/ruby
file = File.open( "20181108.onlyKTcodes.csv", "r")
file.each_line do |line|
  serial_no = line.strip
  item = Item.find_by( serial: serial_no )
  puts line unless item
end
file.close
