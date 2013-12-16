module CbNitride
  class NullItem
    attr_reader :diamond_number

    def initialize(diamond_number)
      @diamond_number = diamond_number
    end

    def nil?
      true
    end

  end
end
