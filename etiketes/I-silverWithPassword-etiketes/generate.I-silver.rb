require "digest"

require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

LabelsType = "AveryL6009_Canon"

SRV_URL = "srv-1tee-moiron.ira.sch.gr"
SRV_PORT= "3000"
tmp_dir = "./tmp"
katagrafi="1803"

if not File.directory?(tmp_dir) 
  puts "Error! Temporary directory does not exists"
  exit
end

if not Dir.empty?(tmp_dir)
  puts "Warning! Target directory (#{tmp_dir}) not empty."
  puts "It is strongly recommented to empty it before running this program."
end

puts "Please provide secret password to be user as salt for secure hash."
puts "WARNING : PASSWORD WILL BE SHOWN HERE IN PLAINTEXT"
password = gets.strip

serials = []
count=0
96.times do |no|
  number = 1 + no

  serial = sprintf "I%s%04d", katagrafi, number
  serials << serial #Μία μόνο για το αντικείμενο

  #break if (count+=1) > 2
end

Prawn::Labels.generate("etiketes-silver.pdf", serials, :type => LabelsType) do |pdf, serial|
  pdf.font "FreeMono.ttf"

  serial_security = Digest::MD5.hexdigest( serial + password )

  qrcode = RQRCode::QRCode.new("http://#{SRV_URL}:#{SRV_PORT}/I/#{serial}?sh=#{serial_security}")
  svg = qrcode.as_svg

  filename = "#{tmp_dir}/#{serial}.svg"
  if File.exist?( filename ) 
    puts "Warning! Duplicate code for room, unless you forgot to clean tmp/"
    puts filename
  end
  IO.write(filename, svg.to_s)

  pdf.svg IO.read(filename), at: [4,55], width: 50, height: 50

  y = 49
  pdf.draw_text "ΕΠΑΛ",       at: [55,y], size: 10
  pdf.draw_text "ΜΟΙΡΩΝ",     at: [55,y-=10], size: 10
  pdf.draw_text serial,    at: [55,y=6], size: 10
end

if LabelsType.start_with?("AveryL6009") then puts "Watch it : SILVER LABELS!" end
