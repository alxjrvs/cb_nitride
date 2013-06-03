require 'mechanize'
require 'nokogiri'

module CbNitride
  class PublicHasher
    attr_reader :diamond_number, :agent

    BASE_URL = "http://www.previewsworld.com/Home/1/1/71/952?stockItemID="
    TITLE_CODE = ".StockCodeDescription"
    IMAGE_CODE = ".StockCodeImage"
    PUBLISHER_CODE = ".StockCodePublisher"
    CREATOR_CODE = ".StockCodeCreators"
    DESCRIPTION_CODE = ".PreviewsHtml"
    RELEASE_CODE = ".StockCodeInShopsDate"
    PRICE_CODE  = ".StockCodeSrp"


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

    def issue_hash
      {
      title: find_text_with(TITLE_CODE),
      image_url: find_text_with(IMAGE_CODE),
      publisher: find_text_with(PUBLISHER_CODE).gsub("Publisher :", ""),
      creators: find_text_with(CREATOR_CODE),
      description: find_text_with(DESCRIPTION_CODE),
      release_date: find_text_with(RELEASE_CODE).match(/\d+[\/]\d+[\/]\d+/).to_s,
      price: find_text_with(PRICE_CODE).match(/\d+[.]\d+/).to_s.to_f
      }
    end

  end
end
