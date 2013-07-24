require 'pry'
require "cb_nitride/version"
require "cb_nitride/exceptions"
require "cb_nitride/module_methods"
require "cb_nitride/hasher_methods"
require "cb_nitride/configuration"
require "cb_nitride/diamond_login"
require "cb_nitride/public_hasher"
require "cb_nitride/private_hasher"
require "cb_nitride/category_sorter"
require "cb_nitride/diamond_item"

module CbNitride
  def self.issue(diamond_number, qualified = false)
    unless qualified?
      PublicHasher.issue(diamond_number)
    else
      PrivateHasher.issue(diamond_number)
    end
  end
end
