require 'rubygems'

using_git = File.exist?(File.expand_path('../../.git/', __FILE__))
require 'bundler/setup' if using_git

require File.expand_path('../../lib/cb_nitride.rb', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
require 'pry'
require 'vcr'


VCR.configure do |c|
  c.cassette_library_dir = 'test/cassettes'
  c.default_cassette_options = { record: :new_episodes}
end

CbNitride.configure do |c|
  c.username = ""
  c.password = ""
  c.account_number = ""
end

module Recordable
  def setup
    VCR.insert_cassette(__name__)
  end

  def teardown
    VCR.eject_cassette
  end
end
