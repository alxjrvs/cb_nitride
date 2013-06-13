module CbNitride
  module HasherMethods

    def find_text_with(code)
      item_page.css(code).text.strip
    end

    def is_valid_diamond_code
      @is_valid_diamond_code ||= item_page.css(container_class).empty? ? false : true
    end

    def return_hash(state)
      return {} unless is_valid_diamond_code
      if is_issue?
        {
          issue: branded_hash,
          type: state
        }
      elsif is_variant?
        {
          variant: branded_hash,
          type: state
        }
      elsif is_collection?
        {
          collection: branded_hash,
          type: state
        }
      elsif is_merch?
        {
          merchandise: branded_hash,
          type: state
        }
      else
        {
          other: branded_hash,
          type: state
        }
      end
    end

    def get_image_url(base_url)
      base_url + item_page.css(image_class).children[1].attributes["src"].value
    end

    def item_page
      @item_page ||= Nokogiri::HTML(agent.get(search_url + diamond_number).content)
    end
  end
end
