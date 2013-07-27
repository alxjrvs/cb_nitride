module CbNitride
  class DiamondItem

    attr_reader :state, :diamond_number, :title, :stock_number, :image_url, :publisher, :creators, :description, :release_date, :price, :category_code

    def initialize(options = {})
      @state = options[:state]
      @title = options[:title]
      @diamond_number = options[:diamond_number]
      @stock_number = options[:stock_number]
      @image_url = options[:image_url]
      @publisher = options[:publisher]
      @creators = options[:creators]
      @description = options[:description]
      @release_date = options[:release_date]
      @price = options[:price]
      @category_code = options[:category_code]
      @errors = options[:errors]
    end

    def writer
      @_writer ||= creators_hash["W"]
    end

    def artist
      @_artist ||= creators_hash["A"]
    end

    def cover_artist
      @_cover_artist ||= creators_hash["CA"]
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
          value = true if title.match(/(CVR)\s[B-Z]/)
        end
        value
    end
  end
end