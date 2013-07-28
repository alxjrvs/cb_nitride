module CbNitride
  class DiamondNumberGenerator

    #TODO: Refactor into DiamondNumberSet with sorting capabilities instead of array of array of array.

    NEW_RELEASES_URL = "http://www.previewsworld.com/Home/1/1/71/952"
    UPCOMING_RELEASES_URL = "http://www.previewsworld.com/Home/1/1/71/954"

    attr_reader :month, :year

    MONTH_CODES = ['JAN', 'FEB', 'MAR', 'APR', 'JUN', 'MAY', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
    YEAR_CODES = ['06','07','08','09','10','11','12','13']

    def self.generate_all!
      new.brute_force_formatted_numbers
    end

    def self.generate_imminent!
      new.imminent_releases
    end

    def initialize(year_range = nil, month_range = nil, options = {})
      @year_range = year_range || YEAR_CODES
      @month_range = month_range || MONTH_CODES
    end

    def imminent_releases
      [new_releases_page, upcoming_releases_page].map do |page|
        extract_diamond_numbers(page)
      end.flatten
    end

    def brute_force_formatted_numbers
      year_codes.map do |year|
        month_codes.map do |month|
          generate_numbers(year, month)
        end
      end
    end

    def all_for_year
      month_codes.map do |month|
        generate_numbers(year, month)
      end.flatten
    end

    private

    def generate_numbers(year, month)
      (1...3000).map do |num|
        format_number(year, month, num)
      end.flatten.compact
    end

    def format_number(year, month, num)
      month + year + calculate_zeroes(num)
    end

    def calculate_zeroes(num)
      ("0" * (4 - num.to_s.size)) + num.to_s
    end

    def item_page(url)
      Nokogiri::HTML(Mechanize.new.get(url).content)
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

    def new_releases_page
      @_new_releases_page ||= item_page(NEW_RELEASES_URL)
    end

    def upcoming_releases_page
      @_upcoming_releases_page ||= item_page(UPCOMING_RELEASES_URL)
    end
  end
end
