#!/usr/bin/env ruby

MAX_WORDS = 500
MAX_RESULTS = 25

# Filters a word-dictionary based on NYT letterboxed game
class DictionaryFilter
  attr_reader :dict_path

  def initialize(dict_path, letter_sets)
    @dict_path = dict_path
    @letters = []
    @forbidden_sequences = []
    process_letter_sets(letter_sets)
  end

  def process_letter_sets(letter_sets)
    letter_sets.each do |set|
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
    filtered_word_list = []
    File.readlines(@dict_path).map(&:strip).each do |word|
      break if filtered_word_list.size >= MAX_WORDS

      filtered_word_list.<<(word) if word.chars.all? { |char| @letters.include?(char) } &&
        @forbidden_sequences.none? { |seq| word.include?(seq) }
    end
    filtered_word_list.sort_by { |word| [-word.chars.uniq.length, word] }
  end

  def filter_words_that_start_with(input_word)
    filtered_word_list = []
    last_letter = input_word[-1]
    remaining_letters = @letters - input_word.chars[0..-2]

    File.readlines(@dict_path).map(&:strip).each do |word|
      break if filtered_word_list.size >= MAX_WORDS

      filtered_word_list.<<(word) if word.start_with?(last_letter) &&
        word.chars.all? { |char| @letters.include?(char) } &&
        remaining_letters.all? { |char| word.include?(char) } &&
        @forbidden_sequences.none? { |seq| word.include?(seq) }
    end
    filtered_word_list.sort_by { |word| [-word.chars.uniq.length, word] }
  end

  def automated_filtering(filtered_words)
    output_pairs = {}
    filtered_words.each do |word|
      $stderr.print('.')
      next if word.size == 1

      matches = filter_words_that_start_with(word)
      next if matches.none?

      matches.each do |match|
        output_pairs[word] ||= []
        output_pairs[word] << match
      end
      break if output_pairs.keys.size > MAX_RESULTS
    end
    warn "\n"
    output_pairs
  end
end

if ARGV.length != 4
  warn "Usage: #{$PROGRAM_NAME} set1 set2 set3 set4\n\te.g. #{$PROGRAM_NAME} ube tms pai ljn\n\n"
  exit
end

# Usage
dict_path = './words.txt'
letter_sets = ARGV
filter = DictionaryFilter.new(dict_path, letter_sets)
filtered_words = filter.filter_words
reversed_filtered_words = []
filtered_words.reverse.each { |word| reversed_filtered_words << word }

# puts "Top #{MAX_WORDS} filtered words:"
# reversed_filtered_words.each { |word| puts word }

filter.automated_filtering(reversed_filtered_words).each_pair { |(k, v)| puts "#{k} -> #{v}" }
