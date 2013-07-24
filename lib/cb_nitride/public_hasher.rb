require 'mechanize'
require 'nokogiri'

module CbNitride
  class PublicHasher
    include HasherMethods
    attr_reader :diamond_number, :agent, :container_class, :search_url, :image_class

    BASE_URL = "http://www.previewsworld.com"
    DIAMOND_NUMBER_SEARCH_PATH = "/Home/1/1/71/952?stockItemID="

    SEARCH_URL = BASE_URL + DIAMOND_NUMBER_SEARCH_PATH

    IMAGE_CLASS = "a.FancyPopupImage"
    CONTAINER_CLASS = ".StockCode"
    TITLE_CLASS = ".StockCodeDescription"
    PUBLISHER_CLASS = ".StockCodePublisher"
    CREATOR_CLASS = ".StockCodeCreators"
    DESCRIPTION_CLASS = ".PreviewsHtml"
    RELEASE_CLASS = ".StockCodeInShopsDate"
    PRICE_CLASS  = ".StockCodeSrp"

    def self.item(diamond_number)
      new(diamond_number).spawn_item
    end

    def initialize(diamond_number)
      @diamond_number = diamond_number
      @agent = Mechanize.new
      check_diamond_validity
    end

    def spawn_item
     DiamondItem.new(branded_hash)

    end

    private

    def get_stock_number
      item_page.css("a.FancyPopupImage").children[1]["alt"].gsub(" Image", "")
    end

    def uncategorized_hash
        @_uncategorized_hash ||= {
        title: find_text_with(TITLE_CLASS),
        diamond_number: diamond_number,
        stock_number: get_stock_number,
        image_url: get_image_url(BASE_URL, IMAGE_CLASS),
        publisher: find_text_with(PUBLISHER_CLASS).gsub(/Publisher:\W*/, ""),
        creators: find_text_with(CREATOR_CLASS),
        description: find_text_with(DESCRIPTION_CLASS),
        release_date: clean_date_string(find_text_with(RELEASE_CLASS)),
        price: clean_price_float(find_text_with(PRICE_CLASS)),
        state: :public
      }
    end

    def branded_hash
      @_branded_hash ||=
        uncategorized_hash.merge!(
          category_code: CategorySorter.new(uncategorized_hash).sort
        )
    end


    def check_diamond_validity
      if item_page.css(CONTAINER_CLASS).empty?
        raise InvalidDiamondNumberError, "Your Diamond Number is Invalid."
      end
    end

    def item_page
      @item_page ||= Nokogiri::HTML(agent.get(SEARCH_URL + diamond_number).content)
    end
  end
end
