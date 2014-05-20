require "pp"
require 'open-uri'
require 'sanitize'
require 'JSON'

def main
	search_string = ARGV[0]

	adjectives = read_words("adjectives.txt")
	page_title, input_words = get_wikipedia_words(search_string)
	
	adjective_counts = get_counts(adjectives, input_words)

	puts "Found page: #{page_title}"

	PP.pp(adjective_counts[-10..-1])
end


def get_counts(adjectives, input_words)
	adjective_counts = {}
	# Set all adjectives to 0
	adjectives.each { |word| adjective_counts[word] = 0 }

	input_words.each do |word|
		if adjective_counts.has_key? word
			adjective_counts[word] = adjective_counts[word] + 1
		end
	end

	sorted_adjectives = adjective_counts.sort_by { |key, value| value }
	return sorted_adjectives
end


def read_words(filename)
	words = []
	File.open(filename, "r") do |in_file|
		in_file.each_line do |line|
			line.split.each { |word| words.push word.downcase }
		end
	end
	return words
end


def get_wikipedia_words(search_string)
	wikipedia_url = "http://en.wikipedia.org/w/api.php?action=parse&page=#{search_string}&format=json&prop=text"
	words = []
	json_string = open(wikipedia_url).read

	page_hash = JSON.parse(json_string)

	begin
		plain_text = Sanitize.clean(page_hash["parse"]["text"]["*"])
	rescue NoMethodError => e
		return "No Page Found", []
	end


	# Get all words in lowercase
	plain_text.split.each { |item| words.push item.strip.downcase }

	return page_hash["parse"]["title"], words 
end


main