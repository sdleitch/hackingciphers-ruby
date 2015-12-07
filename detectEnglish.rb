ENGLISH_WORDS_ARRAY = File.readlines('../dictionary.txt').map(&:chomp)
ENGLISH_WORDS = {}
ENGLISH_WORDS_ARRAY.each { |word| ENGLISH_WORDS[word.chomp] = nil }

def getEnglishCount(message)
  message.upcase!
  message = removeNonLetters(message)
  possibleWords = message.split(' ')

  0.0 if possibleWords == [] # no words at all, so return 0.0

  matches = 0
  possibleWords.each do |word|
    matches += 1 if ENGLISH_WORDS.include?(word)
  end
  return matches.to_f / possibleWords.length
end

def removeNonLetters(message)
  lettersOnly = []
  message.each_char do |char|
    lettersOnly << char if /[a-zA-Z\s]/ === char
  end
  return lettersOnly.join('')
end

def isEnglish?(message, wordPercentage=20, letterPercentage=85)
  # By default, 20% of the words must exist in the dictionary file, and
  # 85% of all the characters in the message must be letters or spaces
  # (not punctuation or numbers).
  wordsMatch = getEnglishCount(message) * 100 >= wordPercentage
  numLetters = removeNonLetters(message).length
  messageLettersPercentage = numLetters.to_f / message.length * 100
  lettersMatch = messageLettersPercentage >= letterPercentage
  return (wordsMatch and lettersMatch)
end
