module CbNitride

    def self.password
      self.configuration.password
    end

    def self.user_name
      self.configuration.user_name
    end

    def self.account_number
      self.configuration.account_number
    end

    def self.configure(configuration = CbNitride::Configuration.new)
      yield configuration if block_given?
      @@configuration = configuration
    end

    def self.configuration
      @@configuration ||= CbNitride::Configuration.new
    end

  class Configuration
    attr_accessor :user_name, :password, :account_number

  end
end
