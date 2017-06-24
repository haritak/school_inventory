require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

LabelsType = "AveryL6009"

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
File.open("2017_06.ΚωδικοίΑιθουσών.txt", encoding:"bom|utf-8").each do |line|
  line = line.strip
  puts ">#{line}<"


  room_name = line[0, line.index(" ")]
  puts ">#{room_name}<"

  npcs = 1
  nprinters = 0
  if ["LAB1", "LAB2", "LAB3", "LAB4", "EN"].include?(room_name)
    npcs = 11
    places_name << room_name + "SERVER"
    places_name << room_name + "RK1"
    places_name << room_name + "RK2"
    nprinters = 1
  elsif ["A1", "A2"].include?(room_name)
    npcs = 2
    nprinters = 2
  elsif [ "B1", "B2"].include?(room_name)
    npcs = 5
    nprinters = 2
  elsif ["EN"].include?(room_name)
    npcs = 8
  else
    puts "SC #{room_name}"
    puts room_name[0]
    puts room_name[0].bytes
    puts room_name.encode!("utf-16", "utf-8")
    puts room_name[0]
    puts room_name[0].bytes
    puts "/"
    puts ["A1", "A2"][0][0].bytes
    puts "--"
  end


  npcs.times do |i|
    places_name << room_name + sprintf("PC%d", i+1)
  end
  nprinters.times do |i|
    places_name << room_name + sprintf("PR%d", i+1)
  end
  
  break if (count+=1) > 2
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
