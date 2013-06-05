require 'mechanize'
require 'nokogiri'

module CbNitride
  class PublicHasher
    attr_reader :diamond_number, :agent

    BASE_URL = "http://www.previewsworld.com/Home/1/1/71/952?stockItemID="
    CONTAINER_CLASS = ".StockCode"
    TITLE_CLASS = ".StockCodeDescription"
    IMAGE_CLASS = ".StockCodeImage"
    PUBLISHER_CLASS = ".StockCodePublisher"
    CREATOR_CLASS = ".StockCodeCreators"
    DESCRIPTION_CLASS = ".PreviewsHtml"
    RELEASE_CLASS = ".StockCodeInShopsDate"
    PRICE_CLASS  = ".StockCodeSrp"


    def self.issue(diamond_number)
      new(diamond_number).issue_hash
    end

    def initialize(diamond_number)
      @diamond_number = diamond_number
      @agent = Mechanize.new
    end

    def issue_page
      @issue_page ||= Nokogiri::HTML(agent.get(BASE_URL + diamond_number).content)
    end

    def find_text_with(code)
      issue_page.css(code).text.strip
    end

    def is_valid_diamond_code
      @is_valid_diamond_code ||= issue_page.css(CONTAINER_CLASS).empty? ? false : true
    end

    def prelim_hash
      return @prelim_hash unless @prelim_hash.nil?
      @prelim_hash = {
      title: find_text_with(TITLE_CLASS),
      image_url: find_text_with(IMAGE_CLASS),
      publisher: find_text_with(PUBLISHER_CLASS).gsub("Publisher :", ""),
      creators: find_text_with(CREATOR_CLASS),
      description: find_text_with(DESCRIPTION_CLASS),
      release_date: find_text_with(RELEASE_CLASS).match(/\d+[\/]\d+[\/]\d+/).to_s,
      price: find_text_with(PRICE_CLASS).match(/\d+[.]\d+/).to_s.to_f
      }
    end

    def is_variant?
      return @is_variant unless @is_variant.nil?
      @is_variant = true if prelim_hash[:title].include? "VAR ED"
      @is_variant = true if prelim_hash[:title].include? "COMBO PACK"
      @is_variant = true if prelim_hash[:title].match(/(CVR)\s[B-Z]/)
      @is_variant = false if @is_variant.nil?
      return @is_variant
    end

    def is_issue?
      return @is_issue unless @is_issue.nil?
      if prelim_hash[:title].match(/(CVR)\s[A]/)
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
      @is_collection = true if prelim_hash[:title].include?(" GN ")
      @is_collection = true if prelim_hash[:title].include?(" TP ")
      @is_collection = true if prelim_hash[:title].match(/\s(VOL)\s\d+/)
      @is_collection = false if prelim_hash[:title].match(/\s[#]\d+/)
      @is_collection = false if @is_collection.nil?
      return @is_collection
    end

    def is_merch?
      return @is_merch unless @is_merch.nil?
      case prelim_hash[:creators]
      when ""
        @is_merch = true
      else
        @is_merch = false
      end
      return @is_merch
    end

    def issue_hash
      return {} unless is_valid_diamond_code
      prelim_hash.merge({
        issue: is_issue?,
        variant: is_variant?,
        collection: is_collection?,
        merchandise: is_merch?
      })
    end
  end
end
