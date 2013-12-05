require 'pigudf'

# Load this in Pig using something like the following:
# register '/path/to/fog_index.rb' using jruby as fog;
#
# Then, in a GENERATE clause, call fog.index(a_chararray_field)

class FogIndex < PigUdf
    outputSchema "index:chararray"
    def index text
      return nil if text.nil?

      (0.4 * (words_per_sentence(text) + (100 * complex_words_per_word(text)))).to_s
    end

    def words_per_sentence text
      words(text).count.to_f / sentences(text).count
    end

    def complex_words_per_word text
      complex_words(text).count.to_f / words(text).count	 
    end

    def complex_words text
      words(text).reject { |word| syllables(word).count < 3 }
    end

    def sentences text		
      text.split(/[^\.\?!]/).reject(&:empty?)
    end

    def syllables word
      word.split(/[^aeiouy]/).reject(&:empty?)
    end

    def words text
      text.gsub(/[\.,;\?!\"'()]/, "").downcase.split(" ")
    end
end
