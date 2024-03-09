#!/usr/bin/env ruby

# Specify the path to the system's dictionary file
dict_path = '/Users/jthomas/dev/jayteesf/config/words.txt'


# Define the letters and expanded rules for forbidden sequences and repetitions
mandatory_letters = 'spaint'
optional_letters = 'ubeljm'
forbidden_sequences = ['tm', 'pa', 'ai', 'lj', 'jn', 'ub', 'be', 'pp', 'aa', 'ii', 'tt', 'mm', 'll', 'jj', 'nn', 'uu', 'bb', 'ee']

# Function to check if a word violates any forbidden sequence or repetition
def violates_constraints?(word, forbidden_sequences)
  forbidden_sequences.any? { |seq| word.include?(seq) } ||
    word.chars.chunk_while { |i, j| i == j }.any? { |chunk| chunk.length > 1 }
end

# Read words from dictionary and filter based on criteria
File.open(dict_path) do |file|
  file.each do |line|
    word = line.strip.downcase # Remove newline and make lowercase for comparison
    
    # Check if the word starts with 's', includes mandatory letters, does not violate constraints
    if word.start_with?('s') &&
       mandatory_letters.chars.all? { |char| word.include?(char) } &&
       optional_letters.chars.any? { |char| word.include?(char) } &&
       !violates_constraints?(word, forbidden_sequences)

      puts word
    end
  end
end
