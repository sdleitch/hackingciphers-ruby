# Affine Cipher Hacker
# http://inventwithpython.com/hacking (BSD Licensed)

require_relative 'affineCipher'
require_relative 'detectEnglish'
require_relative 'cryptomath'

def hackAffine(message)
  puts "Hacking...\n
        (Press Ctrl-C to quit at any time.)"

  (0..SYMBOLS.length ** 2).each do |key|
    keyA = Affine.getKeyParts(key)[0]
    next if Cryptomath.gcd(keyA, SYMBOLS.length) != 1

    decryptedText = Affine.decryptMessage(key, message, 1000)

    if isEnglish?(decryptedText)
      puts "Possible encryption hack:\n\nKey #{key}: #{decryptedText[0..300]}\n\nEnter 'D' for done, or just press Enter to continue hacking:"
      response = gets
      if response[0].upcase == "D"
        fullDecryptedText = Affine.decryptMessage(key, message)
        File.write("cracked.txt", fullDecryptedText)
        break
      end
    end
  end
end

puts "What file do you want to hack?"
filename = File.read(gets.chomp)
hackAffine(filename)
