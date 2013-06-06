require 'rubygems'

using_git = File.exist?(File.expand_path('../../.git/', __FILE__))
require 'bundler/setup' if using_git

require File.expand_path('../../lib/cb_nitride.rb', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
require 'fakeweb'
require 'pry'
require 'vcr'

VCR.configure do |c|
  c.hook_into :fakeweb
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = { record: :new_episodes}
end


module LoginInformation
  def set_login_data
    CbNitride.configure do |c|
      c.username = "XXXXXX"
      c.account_number = "XXXXXX"
      c.password = "XXXXXX"
    end
  end

  def clear_login_data
    CbNitride.configure do |c|
      c.username = ""
      c.account_number = ""
      c.password = ""
    end
  end
end

module Recordable
  def setup_vcr
    VCR.insert_cassette(__name__ + "_cassette")
  end

  def clear_vcr
    VCR.eject_cassette
  end
end

class MiniTest::Unit::TestCase

end

