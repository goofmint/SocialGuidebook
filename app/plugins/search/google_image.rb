require 'google-search'

module Search
  class GoogleImage
    def initialize(term)
      @term = term
    end
    
    def result
      results = Google::Search::Image.new(:query => @term, :tbs => "iur:fc")
      ary = []
      results.each_with_index do |image, i|
        break if i == 4
        ary << "![](#{image.uri})"
      end
      ary.join("\n")
    end
  end
end
