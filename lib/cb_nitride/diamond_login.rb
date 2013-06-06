require 'mechanize'


module CbNitride

  class InvalidLoginError < StandardError
  end

  class DiamondLogin

    LOGIN_URL = "https://retailerservices.diamondcomics.com/Login/Login"

    HOME_URL = "https://retailerservices.diamondcomics.com/Home/Index"

    attr_accessor :agent

    class << self
      def agent
        self.new.login
      end
    end

    def agent
      @agent ||= login
    end

    def reset_agent
      self.agent = nil
      login
    end

    def login
      empty_agent = Mechanize.new
      page = empty_agent.get(LOGIN_URL)
      empty_agent.user_agent_alias = 'Mac Safari'
      form = page.form
      form.UserName =  CbNitride.username
      form.EnteredCustNo =  CbNitride.account_number
      form.Password =  CbNitride.password
      empty_agent.submit(form)
      agent = empty_agent
      if agent.page.uri.to_s == HOME_URL
        agent
      else
        raise InvalidLoginError
      end
    end

  end
end
