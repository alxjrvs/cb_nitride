module CbNitride

    def self.configure(configuration = CbNitride::Configuration.new)
      yield configuration if block_given?
      @@configuration = configuration
    end

    def self.configuration
      @@configuration ||= CbNitride::Configuration.new
    end

  class Configuration
    attr_accessor :username, :password, :account_number
  end
end
