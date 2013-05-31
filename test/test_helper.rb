require 'rubygems'

using_git = File.exist?(File.expand_path('../../.git/', __FILE__))
require 'bundler/setup' if using_git

require File.expand_path('../../lib/cb_nitride.rb', __FILE__)

require 'minitest/autorun'
require 'minitest/pride'
