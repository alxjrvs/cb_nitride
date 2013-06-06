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

    def self.qualified?
      password && username && account_number ? true : false
    end
end
