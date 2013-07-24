module CbNitride
  class PrivateHasher
    include HasherMethods
    attr_reader :diamond_number, :agent, :container_class, :search_url, :image_class

    BASE_URL = "https://retailerservices.diamondcomics.com"
    DIAMOND_NUMBER_SEARCH_PATH = "/ShoppingList/AddItem/"

    SEARCH_URL = BASE_URL + DIAMOND_NUMBER_SEARCH_PATH

    IMAGE_CLASS = 'a.ImagePopup'
    TITLE_CLASS = '.ItemDetails_ItemName'
    PUBLISHER_CLASS = '.ItemDetails_Publisher'
    CREATOR_CLASS = '.ItemDetails_Creator'
    DESCRIPTION_CLASS = '.ItemDetails_Description'
    CONTAINER_CLASS = '.PopupContent'

    def self.item(diamond_number, agent = DiamondLogin.agent)
      new(diamond_number, agent).spawn_item
    end

    def initialize(diamond_number, agent = DiamondLogin.agent)
      @diamond_number = diamond_number
      @agent = agent
      check_diamond_validity
    end

    def spawn_item
      DiamondItem.new(branded_hash)
    end

    private

    def native_hash
      @native_hash ||= item_page.css('.LookupItemData_Item').map do |l|
        Hash[l.css('.LookupItemData_Label').text.strip => l.css('.LookupItemData_Value').text.strip]
      end.reduce Hash.new, :merge
    end

    def branded_hash
      @branded_hash ||= {
        title: find_text_with(TITLE_CLASS),
        diamond_number: diamond_number,
        stock_number: native_hash["Stock #"],
        image_url: get_image_url(BASE_URL, IMAGE_CLASS),
        publisher: find_text_with(PUBLISHER_CLASS),
        creators: find_text_with(CREATOR_CLASS),
        description: find_text_with(DESCRIPTION_CLASS),
        release_date: clean_date_string(native_hash["Est Ship Date"]),
        price: clean_price_float(native_hash["Price Before Discount"]),
        category_code: native_hash["Category Code"],
        state: :private
      }
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
