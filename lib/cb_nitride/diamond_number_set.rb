module CbNitride
  class DiamondNumberSet
    NEW_RELEASES_URL = "http://www.previewsworld.com/Home/1/1/71/952"
    UPCOMING_RELEASES_URL = "http://www.previewsworld.com/Home/1/1/71/954"
    MONTH_CODES = ['JAN', 'FEB', 'MAR', 'APR', 'JUN', 'MAY', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
    YEAR_CODES = ['96', '97', '98', '99', '00', '01', '02', '03', '04', '05' '06','07','08','09','10','11','12','13']
    POSSIBLE_DIAMOND_NUMBERS = (1...9999)

    def self.generate_imminent_diamond_numbers
      new.imminent_numbers
    end

    def self.generate_recent_diamond_numbers
      generate_for(years: ['06', '07', '08', '09', '10', '11', '12', '13', '14'])
    end

    def self.generate_all_diamond_numbers
      new.brute_force_formatted_numbers
    end

    def self.generate_for(years: years)
      new.brute_force_formatted_numbers(year_range: years)
    end

    def imminent_numbers
      [new_releases_page, upcoming_releases_page].map do |page|
        extract_diamond_numbers(page)
      end.flatten
    end

    def brute_force_formatted_numbers(year_range: YEAR_CODES, month_range: MONTH_CODES)
      year_range.map do |year|
        month_range.map do |month|
          generate_numbers(year, month)
        end
      end
    end

    private

    def all_for_year
      MONTH_CODES.map do |month|
        generate_numbers(year, month)
      end.flatten
    end

    def generate_numbers(year, month)
      POSSIBLE_DIAMOND_NUMBERS.map do |num|
        DiamondNumberFormatter.format(year: year, month: month, num: num)
      end.flatten.compact
    end

    def item_page(url)
      Nokogiri::HTML(Mechanize.new.get(url).content)
    end

    def new_releases_page
      @_new_releases_page ||= item_page(NEW_RELEASES_URL)
    end

    def upcoming_releases_page
      @_upcoming_releases_page ||= item_page(UPCOMING_RELEASES_URL)
    end

    def extract_diamond_numbers(page)
      page.css('a').map do |link|
        if link.attributes["href"].value.include? "stockItemID"
          link.children.text
        else
          nil
        end
      end.compact
    end
  end
end
