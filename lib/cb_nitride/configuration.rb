module CbNitride

    def self.password
      self.configuration.password
    end

    def self.username
      self.configuration.username
    end

    def self.account_number
      self.configuration.account_number
    end

    def self.qualified
      self.configuration.qualified
    end

    def self.configure(configuration = CbNitride::Configuration.new)
      yield configuration if block_given?
      @@configuration = configuration
    end

    def self.configuration
      @@configuration ||= CbNitride::Configuration.new
    end

  class Configuration
    attr_accessor :username, :password, :account_number, :qualified
  end
end
