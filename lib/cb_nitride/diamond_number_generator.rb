module CbNitride
  class DiamondNumberGenerator

    attr_reader :month, :year
    attr_accessor :count

    MONTH_CODES = ['JAN', 'FEB', 'MAR', 'APR', 'JUN', 'MAY', 'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC']
    YEAR_CODES = ['06','07','08','09','10','11','12','13']

    def self.generate
      new.formatted_numbers
    end

    def initialize(year = nil, options = {})
      @target_month = month
      @target_year = year
    end

    def formatted_numbers
      YEAR_CODES.map do |year|
        MONTH_CODES.map do |month|
        generate_numbers(year, month)
        end
      end
    end

    def all_for_year
      MONTH_CODES.map do |month|
        generate_numbers(year, month)
      end.flatten
    end
    private

    def generate_numbers(year, month)
      (1...3000).map do |num|
        format_single_number(year, month, num)
      end.flatten.compact
    end

    def format_single_number(year, month, num)
      month + year + calculate_zeroes(num)
    end

    def formatted_number(num)
      month + year + calculate_zeroes(num)
    end

    def calculate_zeroes(num)
      ("0" * (4 - num.to_s.size)) + num.to_s
    end
  end
end
