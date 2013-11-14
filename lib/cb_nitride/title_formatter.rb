module CbNitride
  class TitleFormatter

    attr_accessor :raw_title

    #TODO: This really only works for variants and issues.

    def initialize(raw_title)
      @raw_title = raw_title
    end

    LONG_PAREN_OF_PATTERN = /[(].*[Oo][fF].*\d+.*[)]/

    def series_title
      @_series_title ||=
        if clean_title.include? "#"
          clean_title.split("#").first.strip
        end
    end

    def special_number
      @_special_number ||= clean_title.match(/#\S+/).to_s.gsub('#', '').strip
    end

    def issue_number
      @_issue_number ||= clean_title.match(/#\d+/).to_s.gsub('#', '').strip.to_i
    end

    def limited_series_max_issue
      @_limited_series_max_issue ||=
        if clean_title.match(LONG_PAREN_OF_PATTERN)
          clean_long_paren_of_text
        else
          nil
        end
    end

    def variant_description
      @_variant_description ||=
        array = clean_title.split(/#\S+/)
        return nil if array.size == 1
        string = array.last.gsub(LONG_PAREN_OF_PATTERN, '').strip
        string.empty? ? nil : string
    end

    def clean_long_paren_of_text
      clean_title.match(LONG_PAREN_OF_PATTERN).to_s.match(/\d+/).to_s.strip.to_i
    end

    def clean_title
      @_clean_title ||= 
        raw_title.gsub(/[(][C].*[)]?/, '').gsub('(MR)', '').gsub('(NET)', '').strip
    end

  end
end
