require 'pry'
require "cb_nitride/version"
require "cb_nitride/module_methods"
require "cb_nitride/configuration"
require "cb_nitride/diamond_login"
require "cb_nitride/public_hasher"

module CbNitride
  def self.issue(diamond_number, qualified = false)
    unless qualified?
      PublicHasher.issue(diamond_number)
    else
      PrivateHasher.issue(diamond_number)
    end
  end
end
