require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

LabelsType = "AveryL6009"

SRV_URL = "srv-1tee-moiron.ira.sch.gr"
SRV_PORT= "3000"
tmp_dir = "./tmp"
katagrafi="201706"

if not File.directory?(tmp_dir) 
  puts "Error! Temporary directory does not exists"
  exit
end

if not Dir.empty?(tmp_dir)
  puts "Warning! Target directory (#{tmp_dir}) not empty."
  puts "It is strongly recommented to empty it before running this program."
end

names = []
description = {}
count=0
File.open("2017_06.ΚωδικοίΑιθουσών.txt").each do |line|
  line = line.strip

  name = line[0, line.index(" ")]
  names << name #Μία για την αίθουσα
  description[name] = line[line.index(" "), line.length].strip

  #break if (count+=1) > 2
end

Prawn::Labels.generate("etiketes.pdf", names, :type => LabelsType) do |pdf, name|
  pdf.font "FreeMono.ttf"
  qrcode = RQRCode::QRCode.new("http://#{SRV_URL}:#{SRV_PORT}/RM/#{name}")
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
  pdf.draw_text description[name], at: [55,5], size: 9
end

if LabelsType=="AveryL6009" then puts "Watch it : SILVER LABELS!" end
