#!/usr/bin/env ruby

WORDS_TO_SHOW = 300
PAIRS_TO_SHOW = 25
class DictionaryFilter
  attr_reader :dict_path
  attr_reader :forbidden_sequences

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
    File.readlines(@dict_path).map(&:strip).select do |word|
      word.chars.all? { |char| @letters.include?(char) } &&
        @forbidden_sequences.none? { |seq| word.include?(seq) }
    end.sort_by { |word| [-word.chars.uniq.length, word] }
  end

  def filter_words_that_start_with(input_word)
    last_letter = input_word[-1]
    remaining_letters = @letters - input_word.chars[0..-2]
    # warn("\nremaining letters:\n\t#{remaining_letters}\n")

    File.readlines(@dict_path).map(&:strip).select do |word|
      word.start_with?(last_letter) &&
        word.chars.all? { |char| @letters.include?(char) } &&
        remaining_letters.all? { |char| word.include?(char) } &&
        @forbidden_sequences.none? { |seq| word.include?(seq) }
    end.sort_by { |word| [-word.chars.uniq.length, word] }
  end

  def automated_filtering(filtered_words)
    output_pairs = []
    filtered_words.each do |word|
      warn("word: #{word}")
      break if word.size == 1
      matches = filter_words_that_start_with(word)
      if matches.any?
        matches.first(WORDS_TO_SHOW).each { |match| output_pairs << [word, match] }
        warn "Chosen word: #{word}"
        #puts 'Remaining output:'
        #matches.first(WORDS_TO_SHOW).each { |word| puts word }
        break output_pairs.size > PAIRS_TO_SHOW
      else
        warn "Skip word: #{word}"
      end
    end
    output_pairs
  end
end

if ARGV.length != 4
  warn "Usage: #{$PROGRAM_NAME} set1 set2 set3 set4\n\te.g. #{$PROGRAM_NAME} ube tms pai ljn\n\n"
  exit
end

# Usage
dict_path = '/Users/jthomas/dev/jayteesf/config/words.txt'
letter_sets = ARGV
filter = DictionaryFilter.new(dict_path, letter_sets)
#warn "\nForbidden sequences:\n\t#{filter.forbidden_sequences}\n\n"
filtered_words = filter.filter_words
reversed_filtered_words = []
filtered_words.first(WORDS_TO_SHOW).reverse.each { |word| reversed_filtered_words << word }

puts "Top #{WORDS_TO_SHOW} filtered words:"
reversed_filtered_words.each { |word| puts word }

filter.automated_filtering(reversed_filtered_words).each { |pair| puts pair.join(', ') }
