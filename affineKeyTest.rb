# This program proves that the keyspace of the affine cipher is limited
# to SYMBOLS.length ^ 2.

require_relative 'afflineCipher'
require_relative 'cryptomath'

message = 'Make things as simple as possible, but not simpler.'
(2...102).each do |keyA|
  key = keyA * SYMBOLS.length + 1

  if Cryptomath.gcd(keyA, SYMBOLS.length) == 1
    p keyA,  Affine.encryptMessage(key, message)
  end
end
