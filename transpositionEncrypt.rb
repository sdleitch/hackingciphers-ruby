module Transposition

  def Transposition.encryptMessage(key, message)
    # Each string in ciphertext represents a column in the grid.
    ciphertext = [''] * key

    # Loop through each column in ciphertext.
    (0...key).each do |column|
      pointer = column

      # Keep looping until pointer goes past length of message
      while pointer < message.length do
        # Place the character at pointer in message at
        # end of the current column in ciphertext
        ciphertext[column] += message[pointer]

        # move pointer
        pointer += key
      end
    end

    return ciphertext.join('')
  end

  def Transposition.decryptMessage(key, message)
    # The number of "columns" in our transposition grid:
    numOfColumns = (Float(message.length) / key).ceil
    # The number of "rows" in our grid will need:
    numOfRows = key
    # The number of "shaded boxes" in the last "column" of the grid:
    numOfShadedBoxes = (numOfColumns * numOfRows) - message.length
    # Each string in plaintext represents a column in the grid.
    plaintext = [''] * numOfColumns

    col = 0
    row = 0

    message.split('').each do |symbol|
      plaintext[col] += symbol
      col += 1 # point to next column

      if (col == numOfColumns) || (col == numOfColumns - 1 && row >= numOfRows - numOfShadedBoxes)
        col = 0
        row += 1
      end
    end
    return plaintext.join('')
  end

end
