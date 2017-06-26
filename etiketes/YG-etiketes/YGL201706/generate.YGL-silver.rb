require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

SRV_URL = "srv-1tee-moiron.ira.sch.gr"
SRV_PORT= "3000"
tmp_dir = "./tmp"
katagrafi="Κατ_201706"

if not File.directory?(tmp_dir) 
  puts "Error! Temporary directory does not exists"
  exit
end

if not Dir.empty?(tmp_dir)
  puts "Warning! Target directory (#{tmp_dir}) not empty."
  puts "It is strongly recommented to empty it before running this program."
end

names = []
100.times do |number|
  name = sprintf "YGL201706%03d", number
  names << name  #Ενα για να μείνει το τιμολόγιο
  names << name  #Ενα για να μπεί πάνω στο αντικείμενο
  names << name  #Ενα για να μπεί στην αναφορά της καταγραφής
end

##Silver labels in a different file

names = []
100.times do |number|
  name = sprintf "YGL201706%03d", number
  names << name  #Ενα για να μπεί πάνω στο αντικείμενο
end
Prawn::Labels.generate("etiketes-silver.pdf", names, :type => "AveryL6009_Canon") do |pdf, name|
  pdf.font "FreeMono.ttf"
  qrcode = RQRCode::QRCode.new("http://#{SRV_URL}:#{SRV_PORT}/KT/#{name}")
  svg = qrcode.as_svg
  IO.write("#{tmp_dir}/#{name}.svg", svg.to_s)

  pdf.svg IO.read("#{tmp_dir}/#{name}.svg"), at: [4,55], width: 50, height: 50

  y = 49
  pdf.draw_text "ΕΠΑΛ",       at: [55,y], size: 10
  pdf.draw_text "ΜΟΙΡΩΝ",     at: [55,y-=10], size: 10
  pdf.draw_text katagrafi,    at: [55,y-=7], size: 7
  pdf.draw_text name,         at: [55,y-=7], size: 7 
end
