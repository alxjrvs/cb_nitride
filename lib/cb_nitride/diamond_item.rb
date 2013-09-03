module CbNitride
  class DiamondItem

    attr_reader :state, :diamond_number, :stock_number, :image_url, :publisher, :creators, :description, :release_date, :price, :category_code, :errors, :raw_title, :image

    def initialize(options = {})
      @state = options[:state]
      @raw_title = options[:title]
      @diamond_number = options[:diamond_number]
      @stock_number = options[:stock_number]
      @image = options[:image]
      @image_url = options[:image_url]
      @publisher = options[:publisher]
      @creators = options[:creators]
      @description = options[:description]
      @release_date = options[:release_date]
      @price = options[:price]
      @category_code = options[:category_code]
      @errors = options[:errors]
    end

    def release_year
      @_release_year ||= release_date.year.to_i
    end

    def author
      @_author ||= creators_hash["W"]
    end

    def artist
      @_artist ||= creators_hash["A"]
    end

    def cover_artist
      @_cover_artist ||= creators_hash["CA"]
    end

    def series_title
      @_series_title ||= title_formatter.series_title || title
    end

    def title
      @_title ||= title_formatter.clean_title
    end

    def special_number
      @_special_number ||= title_formatter.special_number
    end

    def issue_number
      @issue_number ||= title_formatter.issue_number
    end

    def limited_series_max_issue
      @_limited_series_max_issue ||= title_formatter.limited_series_max_issue
    end

    def variant_description
      @_variant_description ||= title_formatter.variant_description
    end

    def product_type?
      return :issue if is_issue?
      return :variant if is_variant?
      return :collection if is_collection?
      return :merchandise if is_merch?
    end

    private

    def creators_hash
      return @_creators_hash if @_creators_hash
      array = creators.split('(').map {|x| x.split(')')}.flatten.map {|x| x.strip}
      hash ={}
      array.each_with_index do |val, i|
        if i.even? || i == 0
          if val.include? '/'
            val.split('/').each_with_index do |key, index|
              instance_variable_set("@key#{index + 1}".to_sym, key)
            end
          else
            @key = val
          end
        elsif i.odd?
          @value = val
          hash.merge! @key => @value if @key
          hash.merge! @key1 => @value if @key1
          hash.merge! @key2 => @value if @key2
          hash.merge! @key3 => @value if @key3
          @value = nil
          @key = nil
          @key1= nil
          @key2 = nil
          @key3 = nil
        end
      end
      @_creators_hash = hash
    end

    def title_formatter
      @_formatted_title ||= TitleFormatter.new(raw_title)
    end

    def is_collection?
      @_is_collection ||= CategorySorter::COLLECTION_CODE  == category_code
    end

    def is_merch?
      @_is_merch ||= CategorySorter::MERCHANDISE_CODES.include? category_code
    end

    def is_issue?
      @_is_issue ||=
        category_code == CategorySorter::ISSUE_CODE && is_variant? == false
    end

    def is_variant?
      @_is_variant ||=
        value = false
        if category_code == CategorySorter::ISSUE_CODE
          value = true if title.include?("VAR ED")
          value = true if title.include?("COMBO PACK")
          value = true if tit.include?("STANDARD ED")
          value = true if title.include?(" CVR") unless title.include?("REG CVR") || title.include? "CVR A"
        end
        value
    end
  end
end
