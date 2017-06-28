#run this script with:
#bin/rails runner path/to/filename.rb
#
#
#
categories = {
  "SCANNER": "Κάθε είδους scanner",
  "WEBCAM": "Κάθε είδους web camera",
  "CAMERA": "Κάθε είδους κάμερα ή συσκευή εγγραφής βίντεο",
  "SPEAKERS": "Κάθε είδους ηχεία",
  "UPS": "Κάθε είδους σταθεροποιητής τάσης με/χωρίς μπαταρία",
  "SPLITTER": "Κάθε είδους συσκευή κλωνοποίησης σήματος οθόνης/πληκτρολόγιου/ποντικιού",
  "RACK": "Ντουλαπάκι για τον δικτυακό εξοπλισμό",
  "MODEM/ROUTER": "Δρομολογητής κάθε είδους και μεγέθους",
  "WIRELESS": "Ασύρματο σημείο πρόσβασης ή δρομολογητής μικρού μεγέθους με ασύρματο δίκτυο",
  "SWITCH": "Kάθε μεγέθους switch ή hub",
  "PATCH PANEL": "Patch panel, συνήθως εντός rack, εκεί που τερματίζουν τα μπριζάκια εντός του rack",
  "VOIP ADAPTER": "Voice over IP adapter",


  "PROJECTOR":	"Προβολέας",
  "LAPTOP":	"Φορητός υπολογιστής",
  "CPU":	"Κάθε είδους μνήμη επεξεργαστής",
  "RAM":	"Κάθε είδους μνήμη RAM",
  "PSU":	"Κάθε είδους τροφοδοτικό, εσωτερικό ή εξωτερικό",
  "DVD":	"Κάθε είδους player/recorder για CD ή/και DVD",
  "HDD":	"Σκληρός δίσκος (κάθε είδους, SSD, παλιός, IDE, SATA)",
  "MOTHERBOARD":	"Κάθε είδους και μεγέθους μητρική κάρτα",
  "VGA":	"Κάρτα οθόνης (PCI, PCI-Express, οποιασδήποτε σύνδεσης",
  "SOUND CARD":	"Κάρτα ήχου (PCI, PCI-Express, οποιασδήποτε σύνδεσης",
  "NETWORK CARD":	"Κάρτα δικτύου (PCI, PCI-Express, οποιασδήποτε σύνδεσης",
  "KEYBOARD":	"Πληκτρολόγια όλων των ειδών",
  "MONITOR":	"Ολων των ειδών οι οθόνες",
  "MOUSE":	"Ποντικάκια όλων των ειδών",
  "WORKSTATION":	"Κεντρική μονάδα (χωρίς τα περιφερειακά της)",
}

puts "This script will add to your database the default categories and their descriptions."
puts "Since the database does not allow duplicate categories, it's safe to run this script"
puts "more than once."
puts "Press enter to continue"
gets

puts "These are the things that will be added:"
puts
categories.each do |k, v|
  puts "  #{k} : #{v}"
end
puts
puts "Hit enter to insert them to db"
gets

categories.each do |k, v|
    begin
      ItemCategory.create( category: k, description: v )
      puts "#{k}: #{v} inserted"
    rescue ActiveRecord::RecordNotUnique => e
      puts "#{k}: all ready exists"
    end
end

puts "All done"

