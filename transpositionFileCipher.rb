require_relative 'transpositionEncrypt'
require_relative 'transpositionDecrypt'

def main
  inputFilename = 'frankenstein.txt'
  outputFilename = 'frankenstein.encrypted.txt'
  myKey = 10
  puts "Would you like to (E)ncrypt or (D)ecrypt?"
  myMode = gets.downcase[0]
  until myMode == ('e' || 'd')
    puts "Wrong input. Would you like to (E)ncrypt or (D)ecrypt?"
    myMode = gets.downcase[0]
  end

  #Abort if file doesn't exist.
  if !File.exist?(inputFilename)
    puts "The file #{inputFilename} does not exist. Quitting..."
    # exit
  end

  #If output file already exists, ask to overwrite.
  if File.exist?(outputFilename)
    puts "This will overwrite the file #{outputFilename}. (C)ontinue or (Q)uit?"
    response = gets.downcase
    until response[0] == ('q' || 'c')
      puts "Wrong input. (C)ontinue or (Q)uit?"
      response = gets.downcase
    end
    response[0] == 'q' ? exit : nil
  end

  content = File.read(inputFilename)

  puts "#{myMode}ing..."

  startTime = Time.now
  myMode = 'e' ? translated = Encrypt.encryptMessage(myKey, content) : translated = Decrypt.decryptMessage(myKey, content)
  totalTime = (Time.now - startTime).round(2)
  puts "#{myMode}ion time: #{totalTime} seconds"
end

main
