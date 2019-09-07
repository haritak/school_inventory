#!/bin/ruby
require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

SRV_URL = "srv-1tee-moiron.ira.sch.gr"
SRV_PORT= "3000"
tmp_dir = "./tmp"
katagrafi="Κατ20150625"

if not File.directory?(tmp_dir) 
  puts "Error! Temporary directory does not exists"
  exit
end

if not Dir.empty?(tmp_dir)
  puts "Warning! Target directory (#{tmp_dir}) not empty."
  puts "It is strongly recommented to empty it before running this program."
end

names = []
count=0
File.open("20181108.csv").each do |line|
  description = line.split(",")[2]
  next if not description
  next if description==""

  code = line.split(",")[3]
  next if not code
  next if code==""

  code = code.sub "ΚΤ", "KT" #to english
  description = description.sub "MICROSOFT", "MS"
  description = description.sub "GENERIC", "Gen"
  description = description.sub "LOGITECH", "Logit"
  description = description[0..11]
  names << [code, description] #target[0]
  count += 1
  #break if count==50 #This is used for debugging
end

names.sort!
names.each do |name|
  puts "#{name[0]} - #{name[1]}"
end

puts "Starting PDF creation"
counter = 0
Prawn::Labels.generate("etiketes.pdf", names, :type => "AveryL6009_UTAX") do |pdf, name|
  pdf.font "FreeMono.ttf"
  code = name[0]
  description = name[1]
  qrcode = RQRCode::QRCode.new("http://#{SRV_URL}:#{SRV_PORT}/KT/#{code}")
  svg = qrcode.as_svg
  IO.write("#{tmp_dir}/#{name[0]}.svg", svg.to_s)

  pdf.svg IO.read("#{tmp_dir}/#{name[0]}.svg"), at: [4,55], width: 50, height: 50

  y = 49
  pdf.draw_text "ΕΠΑΛ",       at: [55,y], size: 10
  pdf.draw_text "ΜΟΙΡΩΝ",     at: [55,y-=10], size: 10
  pdf.draw_text "",         at: [55,y-=7], size: 7
  pdf.draw_text code,         at: [55,y-=20], size: 7
  pdf.draw_text description,  at: [55,y-=7], size: 7 

  counter += 1
  puts "." if counter%100 == 0 
end
