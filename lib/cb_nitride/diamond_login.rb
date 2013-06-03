require 'mechanize'
module CbNitride
  class DiamondLogin

    LOGIN_URL = "https://retailerservices.diamondcomics.com/Login/Login"

    HOME_URL = "https://retailerservices.diamondcomics.com/Home/Index"

    attr_accessor :agent

    def self.agent
      new.login
    end

    def agent
      @agent ||= new.login
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
      return agent
    end
  end
end
