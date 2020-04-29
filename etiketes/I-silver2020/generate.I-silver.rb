#!/usr/bin/ruby
require "digest"

require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

LabelsType = "AveryL6009_MS312dn"

SRV_URL = "srv-1tee-moiron.ira.sch.gr"
SRV_PORT= "3000"
Tmp_dir = "./tmp"
Output_pdf = "etiketes-silver.pdf"
NumberOfDistinctCodes = 2*48 #48 stickers on single Avery Silver AveryL6009


if File.exist?(Output_pdf)
  puts "Error! File #{Output_pdf} exists!"
  puts "Please remove it to continue"
  exit
end


if not File.directory?(Tmp_dir) 
  puts "Error! Temporary directory does not exists"
  exit
end

if not Dir.empty?(Tmp_dir)
  puts "Warning! Target directory (#{Tmp_dir}) not empty."
  puts "It is strongly recommented to empty it before running this program."
  exit
end

puts "Please provide secret password to be user as salt for secure hash."
puts "WARNING : PASSWORD WILL BE SHOWN HERE IN PLAINTEXT"
password = gets.strip

Katagrafi="2004"
serials = []
count=0

#pID = plain ID
#sID = secure ID
targets=["sID"] #, "sID"] #, "τιμολόγιο", "αναφορά", "spare"]
NumberOfDistinctCodes.times do |no|
  number = 1 + no

  serial = sprintf "I%s%04d", Katagrafi, number
  targets.each { serials << serial }

  #break if (count+=1) > 2
end

tid = 0
previous_serial = nil
Prawn::Labels.generate(Output_pdf, serials, :type => LabelsType) do |pdf, serial|
  filename = "#{Tmp_dir}/#{serial}.svg"

  if previous_serial != serial 
    previous_serial = serial

    pdf.font "FreeMono.ttf"
    serial_security = Digest::MD5.hexdigest( serial + password )
    p serial_security

    qrcode = RQRCode::QRCode.new("http://#{SRV_URL}:#{SRV_PORT}/I/#{serial}?sh=#{serial_security}")
    svg = qrcode.as_svg
    if File.exist?( filename ) 
      puts "Warning! Duplicate code for #{serial}!"
      puts filename
      exit
    end
    IO.write(filename, svg.to_s)
  end

  pdf.stroke_bounds #bounding box
  pdf.svg IO.read(filename), at: [4,55], width: 50, height: 50

  y = 49
  pdf.draw_text "ΕΠΑΛ",         at: [55,y], size: 10
  pdf.draw_text "ΜΟΙΡΩΝ",       at: [55,y-=10], size: 10
  pdf.draw_text serial,         at: [55,y-=10], size: 10
  pdf.draw_text targets[tid],   at: [55,y-=20], size: 7

  tid=0 if (tid+=1) > (targets.length-1)
end

if LabelsType.start_with?("AveryL6009") then puts "Watch it : SILVER LABELS!" end
