module CbNitride
  module HasherMethods

    attr_accessor :error_array

    def error_array
      @error_array ||= []
    end

    def find_text_with(code)
      item_page.css(code).text.strip
    end

    def get_image_url(base_url, image_class)
      image_container = item_page.css(image_class)
      if image_container.empty?
        error_array << "No Image"
      else
        base_url + item_page.css(image_class).children[1].attributes["src"].value
      end
    end

    def clean_price_float(price)
      price.match(/\d+[.]\d+/).to_s.to_f
    end

    def clean_date_string(date)
      if date == ""
        error_array << "No Release Date"
      else
        Date.strptime(date.match(/\d+[\/]\d+[\/]\d+/).to_s, "%m/%d/%Y")
      end
    end
  end
end
