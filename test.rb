#!/usr/bin/env ruby

# Define a method to check if a word violates any of the adjacency rules
def violates_rules?(word, rules)
  rules.any? do |rule|
    rule.each_cons(2).any? { |a, b| word.include?(a + b) }
  end
end

# Define basic components and rules
mandatory_start = 's'
mandatory_includes = 'paint'
optional_letters = 'ubeljm'.chars
rules = [['t', 'm'], ['p', 'a', 'i'], ['l', 'j', 'n'], ['u', 'b', 'e']]

# A simple method to attempt adding letters without violating rules
# Note: This is a basic and not exhaustive method
def attempt_word_construction(mandatory_start, mandatory_includes, optional_letters, rules)
  # Start with mandatory parts
  base = mandatory_start + mandatory_includes
  words = [base]

  # Attempt to add optional letters in various positions, checking rules
  optional_letters.each do |letter|
    new_words = []
    words.each do |word|
      (0..word.length).each do |i|
        new_word = word.dup.insert(i, letter)
        unless violates_rules?(new_word, rules)
          new_words << new_word
        end
      end
    end
    words.concat(new_words)
  end
  
  words.uniq
end

# Since this method is highly simplified and not optimized, it may not handle all complexities or generate all valid combinations
words = attempt_word_construction(mandatory_start, mandatory_includes, optional_letters, rules)

# Print some of the generated words
puts words.take(10)

