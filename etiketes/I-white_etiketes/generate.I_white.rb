require 'rqrcode' #https://github.com/whomwah/rqrcode
require 'prawn/labels' #https://github.com/madriska/prawn-labels
require 'prawn-svg' #https://github.com/mogest/prawn-svg

Prawn::Labels.types = 'custom.yaml'

LabelsType = "TypoLabel6511"

SRV_URL = "srv-1tee-moiron.ira.sch.gr"
SRV_PORT= "3000"
tmp_dir = "./tmp"
katagrafi="180321"

if not File.directory?(tmp_dir) 
  puts "Error! Temporary directory does not exists"
  exit
end

if not Dir.empty?(tmp_dir)
  puts "Warning! Target directory (#{tmp_dir}) not empty."
  puts "It is strongly recommented to empty it before running this program."
end

names = []
startAt = 01 # inclusive 
             # 2017 09 04
breakAt = 20 # 2017 09 04 (each A4 holds exactly 10 leaving two blanks)

count = startAt
100.times do |serial|
  code = sprintf "I#{katagrafi}%03d", startAt + serial

  names << code #Μία για το τιμολόγιο
  names << code #Μία για το αντικείμενο
  names << code #Μία για την αναφορά

  break if not (count+=1) <= breakAt
end

targets=["τιμολόγιο", "", "αναφορά"]
tid=0

Prawn::Labels.generate("etiketes.pdf", names, :type => LabelsType) do |pdf, name|
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

  tid=0 if (tid+=1)>2

end
