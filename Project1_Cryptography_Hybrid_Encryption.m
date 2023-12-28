%{
  Members: Muhammad Aliff Iman Bin Abd Rasid (2110487), Amir Hamzah Bin Ibrahim (2116513), Mohamad Syafiq Asyraf Bin Bharudin (2116239)
  Lecturer: Dr. Zainab Senan Mahmod Attar Bashi
  Project: Hybrid encryption using classical encryption techniques: Monoalphabetic Cipher, Caesar Cipher, Rail Fence Cipher and Vernam Cipher algorithms.
%}

function Project1_Cryptography_Hybrid_Encryption()

    % ---------------------------------------GETTING INPUT---------------------------------------
    % Prompt user for input
    plaintext = input('Enter the plaintext: ', 's');
    caesarShift = input('Enter the Caesar shift value (0 to 25): ');
    railFenceRows = input('Enter the number of rows for Rail Fence Cipher: ');
    key = input('Enter the key for Vernam Cipher: ', 's');

    % ---------------------------------------ENCRYPTION---------------------------------------
    % Apply Monoalphabetic Cipher
    monoalphabeticEncryptedText = monoalphabetic_cipher(plaintext);

    % Display the results for Monoalphabetic Cipher
    fprintf('Monoalphabetic Cipher:\n');
    fprintf('Plaintext:  %s\n', plaintext);
    fprintf('Encrypted:  %s\n', monoalphabeticEncryptedText);
    fprintf('\n');

    % Apply Caesar Cipher
    caesarEncryptedText = shiftCipher(monoalphabeticEncryptedText, caesarShift);

    % Display the results for Caesar Cipher
    fprintf('Caesar Cipher:\n');
    fprintf('Plaintext:  %s\n', monoalphabeticEncryptedText);
    fprintf('Encrypted:  %s\n', caesarEncryptedText);
    fprintf('\n');

    % Apply Rail Fence Cipher to the output of Caesar Cipher
    railFenceEncryptedText = railFenceCipher(caesarEncryptedText, railFenceRows);

    % Display the results for Rail Fence Cipher
    fprintf('Rail Fence Cipher:\n');
    fprintf('Encrypted:  %s\n', railFenceEncryptedText);
    fprintf('\n');

    % Apply Vernam Cipher to the output of Rail Fence Cipher
    % Explanation: (railFenceEncryptedText+0, key+0) => Converts each character in plaintext to its ASCII value.
    %              (mod(0:numel(plaintext+0)-1, numel(key+0))+1) => Creates an index vector by taking the modulo operation to repeat the key to match the length of the railFenceEncryptedText.
    %              (bitxor) => Performs bitwise XOR operation between numeric vectors obtained from railFenceEncryptedText and the generated key.
    %              (char) => Converts numeric result into character. 
    vernamCipherText = char(bitxor(railFenceEncryptedText+0, key(mod(0:numel(railFenceEncryptedText+0)-1, numel(key+0))+1)+0));

    % Display the results for Vernam Cipher
    fprintf('Vernam Cipher:\n');
    fprintf('Encrypted:  %s\n', vernamCipherText);
    fprintf('\n');   

    % Combine the results
    combinedEncryptedText = vernamCipherText;

    % Display the combined result
    fprintf('Combined Encrypted Text: %s\n', combinedEncryptedText);
    
    % ---------------------------------------DECRYPTION---------------------------------------
    % Decryption Process
    fprintf('--- Decryption Process ---\n');

    % Decrypt Vernam Cipher
    % Explanation: (combinedEncryptedText+0, key+0) => Converts each character in plaintext to its ASCII value.
    %              (mod(0:numel(combinedEncryptedText+0)-1, numel(key+0))+1) => Creates an index vector by taking the modulo operation to repeat the key to match the length of the combinedEncryptedText.
    %              (bitxor) => Performs bitwise XOR operation between numeric vectors obtained from combinedEncryptedText and the generated key.
    %              (char) => Converts numeric result into character. 
    vernamDecryptedText = char(bitxor(combinedEncryptedText+0, key(mod(0:numel(combinedEncryptedText+0)-1, numel(key+0))+1)+0));
    
    % Display the result for Vernam Cipher Decryption
    fprintf('Vernam Decipher:\n');
    fprintf('Encrypted:  %s\n', combinedEncryptedText);
    fprintf('Decrypted:  %s\n', vernamDecryptedText);
    fprintf('\n');    

    % Decrypt Rail Fence Cipher
    caesarDecryptedText = railFenceDecipher(vernamDecryptedText, railFenceRows);

    % Display the results for Rail Fence Cipher Decryption
    fprintf('Rail Fence Decipher:\n');
    fprintf('Encrypted:  %s\n', vernamDecryptedText);
    fprintf('Decrypted:  %s\n', caesarDecryptedText);
    fprintf('\n');

    % Decrypt Caesar Cipher
    monoalphabeticDecryptedText = shiftDecipher(caesarDecryptedText, caesarShift);

    % Display the results for Caesar Cipher Decryption
    fprintf('Caesar Decipher:\n');
    fprintf('Encrypted:  %s\n', caesarDecryptedText);
    fprintf('Decrypted:  %s\n', monoalphabeticDecryptedText);
    fprintf('\n');

    % Decrypt Monoalphabetic Cipher
    plaintextDecryptedText = stringDecryption(monoalphabeticDecryptedText, ['A':'Z'], ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M']);

    % Display the results for Monoalphabetic Cipher Decryption
    fprintf('Monoalphabetic Decipher:\n');
    fprintf('Decrypted:  %s\n', plaintextDecryptedText);
    fprintf('\n');
end

% ---------------------------------------USER-DEFINED FUNCTIONS---------------------------------------

function encryptedString = monoalphabetic_cipher(str)
    normalChar = ['a':'z'];  % Original characters
    codedChar = ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P', 'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', 'Z', 'X', 'C', 'V', 'B', 'N', 'M'];

    % Convert the string to lower case
    strLower = lower(str);

    % Encryption
    encryptedString = '';

    for i = 1:length(strLower)
        for j = 1:26
            if strLower(i) == normalChar(j)
                encryptedString = [encryptedString, codedChar(j)];
                break;
            end

            if strLower(i) < 'a' || strLower(i) > 'z'
                encryptedString = [encryptedString, strLower(i)];
                break;
            end
        end
    end
end

function encryptedText = shiftCipher(text, shift)
    % Convert the text to uppercase for simplicity
    text = upper(text);

    % Check if the shift is within the valid range (0 to 25)
    if shift < 0 || shift > 25
        error('Shift value must be between 0 and 25.');
    end

    % Initialize the encrypted text
    encryptedText = '';

    % Iterate through each character in the input text
    for i = 1:length(text)
        % Get the ASCII code of the current character
        charCode = double(text(i));

        % Check if the character is a letter
        if isletter(text(i))
            % Shift the character code by the specified amount
            charCode = charCode + shift;

            % Handle wrap-around for letters beyond 'Z'
            if charCode > double('Z')
                charCode = charCode - 26;
            end
        end

        % Append the encrypted character to the result string
        encryptedText = [encryptedText, char(charCode)];
    end
end

function railFenceEncryptedText = railFenceCipher(plaintext, numRows)
    % Convert the text to uppercase for simplicity
    plaintext = upper(plaintext);

    % Calculate the number of columns based on the length of the plaintext
    numCols = ceil(length(plaintext) / numRows);

    % Initialize the Rail Fence matrix
    railFenceMatrix = char(zeros(numRows, numCols));

    % Fill the Rail Fence matrix with characters from the plaintext
    index = 1;
    for col = 1:numCols
        for row = 1:numRows
            if index <= length(plaintext)
                railFenceMatrix(row, col) = plaintext(index);
                index = index + 1;
            end
        end
    end

    % Read the Rail Fence cipher text from the matrix
    railFenceEncryptedText = reshape(railFenceMatrix', 1, []);
end

function decryptedString = stringDecryption(s, normalChar, codedChar)
    decryptedString = '';

    for i = 1:length(s)
        for j = 1:26
            if s(i) == codedChar(j)
                decryptedString = [decryptedString, normalChar(j)];
                break;
            end

            if s(i) < 'A' || s(i) > 'Z'
                decryptedString = [decryptedString, s(i)];
                break;
            end
        end
    end
end

function decryptedText = shiftDecipher(text, shift)
    % Convert the text to uppercase for simplicity
    text = upper(text);

    % Check if the shift is within the valid range (0 to 25)
    if shift < 0 || shift > 25
        error('Shift value must be between 0 and 25.');
    end

    % Initialize the decrypted text
    decryptedText = '';

    % Iterate through each character in the input text
    for i = 1:length(text)
        % Get the ASCII code of the current character
        charCode = double(text(i));

        % Check if the character is a letter
        if isletter(text(i))
            % Shift the character code by the inverse of the specified amount
            charCode = charCode - shift;

            % Handle wrap-around for letters before 'A'
            if charCode < double('A')
                charCode = charCode + 26;
            end
        end

        % Append the decrypted character to the result string
        decryptedText = [decryptedText, char(charCode)];
    end
end

function railFenceDecryptedText = railFenceDecipher(encryptedText, numRows)
    % Calculate the number of columns based on the length of the encrypted text
    numCols = ceil(length(encryptedText) / numRows);

    % Initialize the Rail Fence matrix
    railFenceMatrix = char(zeros(numRows, numCols));

    % Initialize the counter for the characters
    charIndex = 1;

    % Fill the Rail Fence matrix with characters from the encrypted text
    for row = 1:numRows
        for col = 1:numCols
            if charIndex <= length(encryptedText)
                railFenceMatrix(row, col) = encryptedText(charIndex);
                charIndex = charIndex + 1;
            end
        end
    end

    % Reconstruct the Rail Fence plain text from the matrix
    railFenceDecryptedText = '';
    for col = 1:numCols
        for row = 1:numRows
            if railFenceMatrix(row, col) ~= 0
                railFenceDecryptedText = [railFenceDecryptedText, railFenceMatrix(row, col)];
            end
        end
    end
end
%{
  Externals/Repositories:
  - https://github.com/binaryassasins
  - https://github.com/Alepiimanz
%}