require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

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

names = []
count=0
96.times do |no|
  number = 1 + no

  serial = sprintf "I%s%04d", katagrafi, number
  names << serial.strip #Ενα για να μείνει το τιμολόγιο
  names << serial.strip #Ενα για να μπεί πάνω στο αντικείμενο
  names << serial.strip #Δεύτερο για να μπεί στο αντικείμενο
  names << serial.strip #Ενα για να μπεί στην αναφορά της καταγραφής

  #break if (count+=1) > 10
end

targets=["τιμολόγιο", "υλικό 1", "υλικό 2", "αναφορά"]
tid=0

Prawn::Labels.generate("etiketes.pdf", names, :type => "TypoLabel6511") do |pdf, name|
  pdf.font "FreeMono.ttf"
  qrcode = RQRCode::QRCode.new("http://#{SRV_URL}:#{SRV_PORT}/I/#{name}")
  svg = qrcode.as_svg
  IO.write("#{tmp_dir}/#{name}.svg", svg.to_s)

  pdf.svg IO.read("#{tmp_dir}/#{name}.svg"), at: [4,55], width: 50, height: 50

  y = 49
  pdf.draw_text "ΕΠΑΛ",       at: [55,y], size: 10
  pdf.draw_text "ΜΟΙΡΩΝ",     at: [55,y-=10], size: 10
  pdf.draw_text katagrafi,    at: [55,y-=7], size: 7
  pdf.draw_text targets[tid], at: [55,y-=20], size: 7
  pdf.draw_text name,         at: [55,y-=7], size: 7 

  tid=0 if (tid+=1)> (targets.length-1)

end
