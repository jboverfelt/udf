require 'pigudf'

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
