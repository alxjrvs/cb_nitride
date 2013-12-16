require "cb_nitride/version"
require "cb_nitride/exceptions"
require "cb_nitride/module_methods"
require "cb_nitride/hasher_methods"
require "cb_nitride/configuration"
require "cb_nitride/diamond_login"
require "cb_nitride/public_hasher"
require "cb_nitride/private_hasher"
require "cb_nitride/diamond_item"
require "cb_nitride/diamond_number_set"
require "cb_nitride/diamond_number_formatter"
require "cb_nitride/title_formatter"
require "cb_nitride/null_item"

module CbNitride
  def self.item(diamond_number, options = {})
    if qualified?
      PrivateHasher.item(diamond_number, options[:agent])
    else
      PublicHasher.item(diamond_number)
    end
  end
end
