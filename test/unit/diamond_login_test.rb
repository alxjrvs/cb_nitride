require_relative '../test_helper'

class DiamondLoginTest < MiniTest::Unit::TestCase
  include Recordable

  def test_that_it_can_log_in
    skip "Working out CC bugs"
    la = CbNitride::DiamondLogin.agent

    la.get(CbNitride::DiamondLogin::HOME_URL)
    url = la.page.uri.to_s
    assert_equal url, CbNitride::DiamondLogin::HOME_URL
  end
end
