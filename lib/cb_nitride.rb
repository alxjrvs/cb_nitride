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
require "cb_nitride/diamond_number_generator"
require "cb_nitride/title_formatter"

module CbNitride
  def self.item(diamond_number, options = {})
    if qualified?
      PrivateHasher.item(diamond_number, options[:agent] || DiamondLogin.agent)
    else
      PublicHasher.item(diamond_number)
    end
  end

  def self.generate_diamond_numbers
    @_generate_diamond_numbers ||= DiamondNumberGenerator.generate_all!
  end

  def self.scrape_imminent!
    agent = DiamondLogin.agent if qualified?
    DiamondNumberGenerator.generate_imminent!.map do |diamond_number|
      puts "Looking for #{diamond_number}"
      if qualified?
        diamond_item = item(diamond_number, agent: agent)
      else
        diamond_item = item (diamond_number)
      end
      if diamond_item.nil?
        puts 'Invalid diamond item'
        next
      else
        puts "Recorded #{diamond_item.title} (#{diamond_number})"
        diamond_item
      end
    end
  end

  def self.scrape_all!
    generate_diamond_numbers.flatten.map do |diamond_number|
      diamond_item = item(diamond_number)
      if diamond_item.nil?
        puts "invalid diamond Item"
        next
      else
        puts "Recorded #{diamond_item.title} (#{diamond_number})"
        diamond_item
      end
    end.flatten
  end

end
