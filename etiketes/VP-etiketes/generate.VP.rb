require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

LabelsType = "AveryL6009_Canon"

SRV_URL = "srv-1tee-moiron.ira.sch.gr"
SRV_PORT= "3000"
tmp_dir = "./tmp"

if not File.directory?(tmp_dir) 
  puts "Error! Temporary directory does not exists"
  exit
end

if not Dir.empty?(tmp_dir)
  puts "Warning! Target directory (#{tmp_dir}) not empty."
  puts "It is strongly recommented to empty it before running this program."
end

places_name = []
count=0
#BOM: Byte Order Mark (UTF character)
#if not specified, first labels looks as if it has an
#extra space in front of it
File.open("2017_06.VirtualPlaces.txt", encoding:"bom|utf-8").each do |line|
  places_name << line.strip
  #break if (count+=1) > 2
end

Prawn::Labels.generate("etiketes.pdf", places_name, :type => LabelsType) do |pdf, name|
  pdf.font "FreeMono.ttf"
  qrcode = RQRCode::QRCode.new("http://#{SRV_URL}:#{SRV_PORT}/VP/#{name}")
  svg = qrcode.as_svg

  filename = "#{tmp_dir}/#{name}.svg"
  if File.exist?( filename ) 
    puts "Warning! Duplicate code for room, unless you forgot to clean tmp/"
    puts filename
  end
  IO.write(filename, svg.to_s)

  pdf.svg IO.read(filename), at: [4,55], width: 50, height: 50

  y = 49
  pdf.draw_text "ΕΠΑΛ",       at: [55,y], size: 10
  pdf.draw_text "ΜΟΙΡΩΝ",     at: [55,y-=10], size: 10
  pdf.draw_text name,    at: [55,y-=20], size: 15
end

if LabelsType=="AveryL6009" then puts "Watch it : SILVER LABELS!" end
