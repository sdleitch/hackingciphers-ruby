require_relative 'affineCipher'

def main
  myMode = ''
  myKey = nil

  until myMode == 'encrypt' || myMode == 'decrypt'
    puts "Would you like to (E)ncrypt or (D)ecrypt?"
    input = gets.downcase
    if input[0] == 'e'
      myMode = 'encrypt'
      myKey = Affine.getRandomKey
    elsif input[0] == 'd'
      myMode = 'decrypt'
      until myKey.is_a?(Integer) && myKey != 0
        puts "What's your key?"
        myKey = gets.to_i
      end
    end
  end

  puts "What file do you want to #{myMode}?"
  inputFilename = gets.chomp
  outputFilename = inputFilename.sub(".", ".#{myMode}ed.")

  if !File.exist?(inputFilename)
    puts "The file #{inputFilename} does not exist.\nQuitting..."
  end

  #If output file already exists, ask to overwrite.
  if File.exist?(outputFilename)
    response = ''
    until response[0] == 'q' || response[0] == 'c'
      puts "This will overwrite the file #{outputFilename}. (C)ontinue or (Q)uit?"
      response = gets.downcase
    end
    response[0] == 'q' ? exit : nil
  end

  content = File.read(inputFilename)

  puts myMode.capitalize + 'ing...'

  startTime = Time.now
  myMode == 'encrypt' ? translated = Affine.encryptMessage(myKey, content) : translated = Affine.decryptMessage(myKey, content)
  totalTime = (Time.now - startTime).round(2)
  puts "\n#{myMode.capitalize}ion time: #{totalTime} seconds"
  puts "Your key is: #{myKey}"
  File.write(outputFilename, translated)
end

main
