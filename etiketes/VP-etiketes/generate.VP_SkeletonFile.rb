places_name = []
count=0
#BOM: Byte Order Mark (UTF character)
#if not specified, first labels looks as if it has an
#extra space in front of it
File.open("2017_06.ΚωδικοίΑιθουσών.txt", encoding:"bom|utf-8").each do |line|
  line = line.strip

  room_name = line[0, line.index(" ")]

  npcs = 1
  nprinters = 0
  if ["LAB1", "LAB2", "LAB3", "LAB4", "EN"].include?(room_name)
    npcs = 11
    places_name << room_name + "svr"
    places_name << room_name + "rack1"
    nprinters = 1
  elsif ["A1", "A2"].include?(room_name)
    npcs = 2
    nprinters = 1
  elsif [ "B1", "B2"].include?(room_name)
    npcs = 4
    nprinters = 1
  elsif ["EN"].include?(room_name)
    npcs = 8
  elsif room_name.start_with?("RM")
    if room_name.start_with?("RM20")
      npcs = 1
    else
      npcs = 0
    end
  end


  npcs.times do |i|
    places_name << room_name + sprintf("pc%d", i+1)
  end
  nprinters.times do |i|
    places_name << room_name + sprintf("pr%d", i+1)
  end
  
  #break if (count+=1) > 2
end

places_name.each do |p|
  puts p
end
