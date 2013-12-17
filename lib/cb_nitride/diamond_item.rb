module CbNitride
  class DiamondItem

    SHORT_PAREN_OF_PATTERN = /\s*[O][f][(]/

    attr_accessor :state, :diamond_number, :stock_number, :image_url, :publisher, :creators, :description, :release_date, :price, :category_code, :errors, :raw_title, :image

    def initialize(options = {})
      @state = options[:state]
      @raw_title = options[:title].sub(SHORT_PAREN_OF_PATTERN, ' (Of ')
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
  end
end
