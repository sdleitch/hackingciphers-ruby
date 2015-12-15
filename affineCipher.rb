# Affine Cipher
require_relative 'cryptomath'
require 'securerandom'

SYMBOLS = %Q( !"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[]\\^_`abcdefghijklmnopqrstuvwxyz{|}~\n\t) # note the space at the front

module Affine

  def Affine.getKeyParts(key)
    keyA = key / SYMBOLS.length
    keyB = key % SYMBOLS.length
    return keyA, keyB
  end

  def Affine.checkKeys(keyA, keyB, mode)
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

  def Affine.encryptMessage(key, message)
    keyA, keyB = Affine.getKeyParts(key)
    Affine.checkKeys(keyA, keyB, 'encrypt')
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

  def Affine.decryptMessage(key, message, decrypt_length=message.length)
    keyA, keyB = getKeyParts(key)
    Affine.checkKeys(keyA, keyB, 'decrypt')
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

  def Affine.getRandomKey
    while true
      keyA = SecureRandom.random_number(SYMBOLS.length) + 2
      keyB = SecureRandom.random_number(SYMBOLS.length) + 2
      if Cryptomath.gcd(keyA, SYMBOLS.length) == 1
        return keyA * SYMBOLS.length + keyB
      end
    end
  end

end
