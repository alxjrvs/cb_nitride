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
      c.username = "XXX"
      c.account_number = "YYY"
      c.password = "ZZZ"
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

module HasherTests

  ISSUE_CODE = "APR130131"
  VARIANT_CODE = "APR130183"
  MERCH_CODE = "MAR131699"
  COLLECTION_CODE = "FEB130068"


  def assert_it_is_a(code)
    codes = [:issue, :merchandise, :variant, :collection] - [code]

    refute_nil @hash[code]

    codes.each do |c|
      assert_nil @hash[c]
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

