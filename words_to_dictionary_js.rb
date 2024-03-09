#!/usr/bin/env ruby

# read_words_to_js_array.rb

# Path to the words.txt file
words_txt_path = './words.txt'

# Path to the output JavaScript file
js_output_path = './src/dictionary.js'

# Read the words from the file
words = File.readlines(words_txt_path).map(&:strip)

# Format the array as a JavaScript array assignment
js_array_assignment = "const dictionary = #{words.inspect};\n"

# Write the JavaScript array assignment to the output file
File.write(js_output_path, js_array_assignment)
