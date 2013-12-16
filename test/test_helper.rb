require 'rubygems'

using_git = File.exist?(File.expand_path('../../.git/', __FILE__))
require 'bundler/setup' if using_git

require File.expand_path('../../lib/cb_nitride.rb', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
require 'webmock'
require 'pry'
require 'vcr'

VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = { record: :new_episodes}
end


module CategoryCodes
    ISSUE_CATEGORY_CODE = "1"
    COLLECTION_CATEGORY_CODE = "3"
    MERCHANDISE_CATEGORY_CODES = ["2", "4", "5", "6", "7", "8", "9", "10", "11", "12", "13", "14", "15", "16"]
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
  BAD_CODE = "FEB1099999"

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

