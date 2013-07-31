require_relative '../test_helper'

class DiamondNumberFormatterTest < MiniTest::Unit::TestCase
  def test_that_it_produces_the_right_string
    number = CbNitride::DiamondNumberFormatter.format(month: "AUG", num:'0831', year: '88')
    assert_equal "AUG880831", number
  end
end
