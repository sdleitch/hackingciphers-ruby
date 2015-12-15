require_relative 'detectEnglish'
require_relative 'transpositionEncrypt'

def hackTransposition(message)
  puts "Hacking...\nThis may take awhile...\n(Press Ctrl-C or Ctrl-D to quit at any time.)"

  (1...message.length).each do |key|
    decryptedText = Transposition.decryptMessage(key, message)
    puts "Trying key: #{key}"

    if isEnglish?(decryptedText)
      puts "Possible encryption hack:\n\nKey #{key}: #{decryptedText[0..300]}\n\nEnter 'D' for done, or just press Enter to continue hacking:"
      response = gets
      if response[0].upcase == "D"
        File.write("cracked.txt", decryptedText)
        break
      end
    end
  end
end

puts "What file do you want to hack?"
filename = File.read(gets.chomp)
hackTransposition(filename)
