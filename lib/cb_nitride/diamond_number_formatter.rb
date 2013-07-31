module CbNitride
  class DiamondNumberFormatter
    attr_reader :month, :year, :num

    def self.format(year: year, month: month, num: num)
      new(year: year, month: month, num: num).format
    end

    def initialize(year: year, month: month, num: num)
      @year = year
      @month = month
      @num = num
    end

    def format
      month + year + calculate_zeroes
    end

    private

    def calculate_zeroes
      ("0" * (4 - num.to_s.size)) + num.to_s
    end
  end
end
