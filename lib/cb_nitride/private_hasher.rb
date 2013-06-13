module CbNitride
  class PrivateHasher
    attr_reader :diamond_number, :agent

    BASE_URL = "https://retailerservices.diamondcomics.com"
    DIAMOND_NUMBER_SEARCH_PATH = "/ShoppingList/AddItem/"
    SEARCH_URL = BASE_URL + DIAMOND_NUMBER_SEARCH_PATH

    ISSUE_CODE = "1"
    COLLECTION_CODE = "3"
    MERCHANDISE_CODES = ["2", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]

    TITLE_CLASS = '.ItemDetails_ItemName'
    PUBLISHER_CLASS = '.ItemDetails_Publisher'
    CREATOR_CLASS = '.ItemDetails_Creator'
    DESCRIPTION_CLASS = '.ItemDetails_Description'
    CONTAINER_CLASS = '.PopupContent'


    def self.item(diamond_number, agent = DiamondLogin.agent)
      new(diamond_number, agent).return_hash
    end

    def initialize(diamond_number, agent = DiamondLogin.agent)
      @diamond_number = diamond_number
      @agent = agent
    end

    def return_hash
      return {} unless is_valid_diamond_code
      if is_issue?
        {
          issue: branded_hash,
          type: :private
        }
      elsif is_variant?
        {
          variant: branded_hash,
          type: :private
        }
      elsif is_collection?
        {
          collection: branded_hash,
          type: :private
        }
      elsif is_merch?
        {
          merchandise: branded_hash,
          type: :private
        }
      else
        {
          other: branded_hash,
          type: :private
        }
      end
    end

    def native_hash
      @native_hash ||= item_page.css('.LookupItemData_Item').map do |l|
        Hash[l.css('.LookupItemData_Label').text.strip => l.css('.LookupItemData_Value').text.strip]
      end.reduce Hash.new, :merge
    end

    private

    def item_page
      @item_page ||= Nokogiri::HTML(agent.get(SEARCH_URL + diamond_number).content)
    end

    def find_text_with(code)
      item_page.css(code).text.strip
    end

    def is_valid_diamond_code
      @is_valid_diamond_code ||= item_page.css(CONTAINER_CLASS).empty? ? false : true
    end

    def get_image_url
      BASE_URL + item_page.css('a.ImagePopup').children[1].attributes["src"].value
    end

    def branded_hash
      @branded_hash ||= {
        title: find_text_with(TITLE_CLASS),
        diamond_number: diamond_number,
        stock_number: native_hash["Stock #"],
        image_url: get_image_url,
        publisher: find_text_with(PUBLISHER_CLASS),
        creators: find_text_with(CREATOR_CLASS),
        description: find_text_with(DESCRIPTION_CLASS),
        release_date: Date.strptime(native_hash["Est Ship Date"].match(/\d+[\/]\d+[\/]\d+/).to_s, "%m/%d/%Y"),
        price: native_hash["Price Before Discount"].match(/\d+[.]\d+/).to_s.to_f
      }
    end

    def category_code
      native_hash["Category Code"]
    end

    def is_variant?
      return @is_variant unless @is_variant.nil?

      if is_collection? || is_merch?
        @is_variant = false
      elsif category_code == ISSUE_CODE
        @is_variant = true if branded_hash[:title].include? "VAR ED"
        @is_variant = true if branded_hash[:title].include? "COMBO PACK"
        @is_variant = true if branded_hash[:title].match(/(CVR)\s[B-Z]/)
        @is_variant = false if @is_variant.nil?
      end
      return @is_variant
    end

    def is_collection?
      return @is_collection unless @is_collection.nil?
      category_code == COLLECTION_CODE
    end

    def is_issue?
      return @is_issue unless @is_issue.nil?
      category_code == ISSUE_CODE unless is_variant?
    end

    def is_merch?
      return @is_merch unless @is_merch.nil?
      MERCHANDISE_CODES.include? category_code
    end
  end
end
