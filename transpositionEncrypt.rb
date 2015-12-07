def encryptMessage(key, message)
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
