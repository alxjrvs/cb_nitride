require_relative '../test_helper'

class ConfigurationTest < MiniTest::Unit::TestCase

  def setup
    CbNitride.configure do |c|
      c.username = "username"
      c.password = "password"
      c.account_number = "12345"
    end
  end

  def test_configuration_settings
    assert_equal CbNitride.username, "username"
    assert_equal CbNitride.password, "password"
    assert_equal CbNitride.account_number, "12345"
  end

end
