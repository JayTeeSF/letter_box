#!/usr/bin/env ruby

class DictionaryFilter
  attr_reader :dict_path
  attr_reader :forbidden_sequences

  def initialize(dict_path)
    @dict_path = dict_path
    @letters = []
    @forbidden_sequences = []
  end

  def prompt_for_letter_sets
    4.times do |i|
      puts "Enter set #{i + 1} of 3 letters (e.g., abc):"
      set = gets.strip
      @letters += set.chars
      generate_forbidden_sequences(set)
    end
    @letters.uniq!
  end

  def generate_forbidden_sequences(set)
    set.chars.each { |char| @forbidden_sequences << char * 2 }
    set.chars.permutation(2).each { |seq| @forbidden_sequences << seq.join }
    @forbidden_sequences.uniq!
  end

  def filter_words
    File.readlines(@dict_path).map(&:strip).select do |word|
      word.chars.all? { |char| @letters.include?(char) } &&
        @forbidden_sequences.none? { |seq| word.include?(seq) }
    end.sort_by { |word| [-word.chars.uniq.length, word] }
  end

  def filter_words_that_start_with(input_word)
    last_letter = input_word[-1]
    remaining_letters = @letters - input_word.chars[1..-1]

    File.readlines(@dict_path).map(&:strip).select do |word|
      word.start_with?(last_letter) &&
        word.chars.all? { |char| @letters.include?(char) } &&
        remaining_letters.all? { |char| word.include?(char) } &&
        @forbidden_sequences.none? { |seq| word.include?(seq) }
    end.sort_by { |word| [-word.chars.uniq.length, word] }
  end

  def prompt_for_words_and_filter(filtered_words)
    loop do
      puts 'Enter a word, or just press Enter to continue:'
      input_word = gets.strip
      break if input_word.empty?

      matches = filter_words_that_start_with(input_word)
      puts 'Filtered words based on your input:'
      matches.first(100).each { |word| puts word }

      puts 'Press Enter to input a new word or Ctrl-C to exit.'
      gets
    end
  end
end

# Usage
dict_path = '/Users/jthomas/dev/jayteesf/config/words.txt'
filter = DictionaryFilter.new(dict_path)
filter.prompt_for_letter_sets
warn "\nForbidden sequences:\n\t#{filter.forbidden_sequences}\n\n"
filtered_words = filter.filter_words

puts 'Top 100 filtered words:'
filtered_words.first(100).each { |word| puts word }

filter.prompt_for_words_and_filter(filtered_words)
