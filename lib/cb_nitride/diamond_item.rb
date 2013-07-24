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
    end

    def product_type?
      return :issue if is_issue?
      return :variant if is_variant?
      return :collection if is_colletion?
      return :merchandise if is_merch?
    end

    private

    def is_collection?
      @_is_collection ||= CategorySorter::COLLECTION_CODE
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
        category_code == CategorySorter::ISSUE_CODE &&
        title.include?("VAR ED") &&
        title.include?("COMBO PACK") &&
        title.match(/(CVR)\s[B-Z]/)
    end
  end
end
