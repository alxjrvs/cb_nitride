require_relative '../test_helper'

class DiamondLoginTest < MiniTest::Unit::TestCase
  include LoginInformation
  include Recordable

  def test_that_it_can_log_in
    setup_vcr
    set_login_data

    da = CbNitride::DiamondLogin.agent
    da.get(CbNitride::DiamondLogin::HOME_URL)
    url = da.page.uri.to_s
    assert_equal url, CbNitride::DiamondLogin::HOME_URL

    clear_vcr
  end

  def test_that_it_fails_with_bad_information
    setup_vcr
    clear_login_data

    assert_raises CbNitride::InvalidLoginError do
      CbNitride::DiamondLogin.agent
    end

    clear_vcr
  end

  def test_that_it_resets_the_agent
    setup_vcr

    a = CbNitride::DiamondLogin.new
    a.login
    first_agent = a.agent
    a.reset_agent
    refute_equal a.agent, first_agent

    clear_vcr
  end
end
