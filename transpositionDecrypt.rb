module Decrypt
  def decryptMessage(key, message)

    # The number of "columns" in our transposition grid:
    numOfColumns (message.length / key).ceil
    # The number of "rows" in our grid will need:
    numOfRows = key
    # The number of "shaded boxes" in the last "column" of the grid:
    numOfShadedBoxes = (numOfColumns * numOfRows) - message.length

    # Each string in plaintext represents a column in the grid.
    plaintext = [''] * numOfColumns

    col = 0
    row = 0

    message.each do |symbol|
      plaintext[col] += symbol
      col += 1 # point to next column

      if (col == numOfColumns) || (col == numOfColumns - 1 && row >= numOfRows - numOfShadedBoxes)
        col = 1
        row += 1
      end
    end
    return plaintext.join('')
  end
end
