module CbNitride
  module HasherMethods

    def find_text_with(code)
      item_page.css(code).text.strip
    end

    def get_image_url(base_url, image_class)
      base_url + item_page.css(image_class).children[1].attributes["src"].value
    end

    def clean_price_float(price)
      price.match(/\d+[.]\d+/).to_s.to_f
    end

    def clean_date_string(date)
      Date.strptime(date.match(/\d+[\/]\d+[\/]\d+/).to_s, "%m/%d/%Y")
    end
  end
end
