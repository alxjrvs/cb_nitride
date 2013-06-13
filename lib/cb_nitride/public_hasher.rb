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

    STATE = :public

    def self.item(diamond_number)
      new(diamond_number).return_hash(STATE)
    end

    def initialize(diamond_number)
      @diamond_number = diamond_number
      @agent = Mechanize.new
      @search_url = SEARCH_URL
      @image_class = IMAGE_CLASS
      @container_class = CONTAINER_CLASS
    end

    private

    def branded_hash
      return @branded_hash unless @branded_hash.nil?
      @branded_hash = {
        title: find_text_with(TITLE_CLASS),
        diamond_number: diamond_number,
        stock_number: item_page.css("a.FancyPopupImage").children[1]["alt"].gsub(" Image", ""),
        image_url: get_image_url(BASE_URL),
        publisher: find_text_with(PUBLISHER_CLASS).gsub(/Publisher:\W*/, ""),
        creators: find_text_with(CREATOR_CLASS),
        description: find_text_with(DESCRIPTION_CLASS),
        release_date: Date.strptime(find_text_with(RELEASE_CLASS).match(/\d+[\/]\d+[\/]\d+/).to_s, "%m/%d/%Y"),
        price: find_text_with(PRICE_CLASS).match(/\d+[.]\d+/).to_s.to_f
      }
    end

    def is_variant?
      return @is_variant unless @is_variant.nil?
      @is_variant = true if branded_hash[:title].include? "VAR ED"
      @is_variant = true if branded_hash[:title].include? "COMBO PACK"
      @is_variant = true if branded_hash[:title].match(/(CVR)\s[B-Z]/)
      @is_variant = false if @is_variant.nil?
      return @is_variant
    end

    def is_issue?
      return @is_issue unless @is_issue.nil?
      if branded_hash[:title].match(/(CVR)\s[A]/)
        @is_issue = true
      elsif is_variant?
        @is_issue = false
      elsif is_collection?
        @is_issue = false
      elsif is_merch?
        @is_issue = false
      else
        @is_issue = true
      end
      return @is_issue
    end

    def is_collection?
      return @is_collection unless @is_collection.nil?
      @is_collection = true if branded_hash[:title].include?(" GN ")
      @is_collection = true if branded_hash[:title].include?(" TP ")
      @is_collection = true if branded_hash[:title].match(/\s(VOL)\s\d+/)
      @is_collection = false if branded_hash[:title].match(/\s[#]\d+/)
      @is_collection = false if @is_collection.nil?
      return @is_collection
    end

    def is_merch?
      return @is_merch unless @is_merch.nil?
      case branded_hash[:creators]
      when ""
        @is_merch = true
      else
        @is_merch = false
      end
      return @is_merch
    end

  end
end
