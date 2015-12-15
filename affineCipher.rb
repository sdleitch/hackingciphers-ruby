# Affine Cipher
require_relative 'cryptomath'
require 'securerandom'

SYMBOLS = %Q( !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]\\^_`abcdefghijklmnopqrstuvwxyz{|}~\n\t) # note the space at the front

def main
  myMode = ''
  myKey = nil

  until myMode == 'encrypt' || myMode == 'decrypt'
    puts "Would you like to (E)ncrypt or (D)ecrypt?"
    input = gets.downcase
    if input[0] == 'e'
      myMode = 'encrypt'
      myKey = getRandomKey
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
  myMode == 'encrypt' ? translated = encryptMessage(myKey, content) : translated = decryptMessage(myKey, content)
  totalTime = (Time.now - startTime).round(2)
  puts "\n#{myMode.capitalize}ion time: #{totalTime} seconds"
  puts "Your key is: #{myKey}"
  File.write(outputFilename, translated)
end

def getKeyParts(key)
  keyA = key / SYMBOLS.length
  keyB = key % SYMBOLS.length
  return keyA, keyB
end

def checkKeys(keyA, keyB, mode)
  case
  when keyA == 1 && mode == 'encrypt'
    abort("The affine cipher becomes incredibly weak when key A is set to 1. Choose a different key.")
  when keyB == 0 && mode == 'encrypt'
    abort("The affine cipher becomes incredibly weak when key B is set to 0. Choose a different key.")
  when keyA < 0 || keyB < 0 || keyB > SYMBOLS.length - 1
    abort("Key A must be greater than 0 and Key B must be between 0 and #{SYMBOLS.length - 1}.")
  when Cryptomath.gcd(keyA, SYMBOLS.length) != 1
    abort("Key A (#{keyA}) and the symbol set size (#{SYMBOLS.length}) are not relatively prime. Choose a different key.")
  end
end

def encryptMessage(key, message)
  keyA, keyB = getKeyParts(key)
  checkKeys(keyA, keyB, 'encrypt')
  ciphertext = ''
  message.each_char do |character|
    if SYMBOLS.include?(character)
      # encrypt this character
      symIndex = SYMBOLS.index(character)
      ciphertext += SYMBOLS[(symIndex * keyA + keyB) % SYMBOLS.length]
    else
      ciphertext += symbol
    end
  end
  return ciphertext
end

def decryptMessage(key, message, decrypt_length=message.length)
  keyA, keyB = getKeyParts(key)
  checkKeys(keyA, keyB, 'decrypt')
  plaintext = ''
  modInverseOfKeyA = Cryptomath.findModInverse(keyA, SYMBOLS.length)

  message[0..decrypt_length].chars.each do |character|
    if SYMBOLS.include?(character)
      # decrypt this character
      symIndex = SYMBOLS.index(character)
      plaintext += SYMBOLS[(symIndex - keyB) * modInverseOfKeyA % SYMBOLS.length]
    else
      plaintext += symbol
    end
  end
  return plaintext
end

def getRandomKey
  while true
    keyA = SecureRandom.random_number(SYMBOLS.length) + 2
    keyB = SecureRandom.random_number(SYMBOLS.length) + 2
    if Cryptomath.gcd(keyA, SYMBOLS.length) == 1
      return keyA * SYMBOLS.length + keyB
    end
  end
end

# main
