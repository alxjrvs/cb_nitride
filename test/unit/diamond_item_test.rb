require_relative '../test_helper'

class DiamondItemTest < MiniTest::Unit::TestCase
  def specific_issue
    @_type ||= CbNitride::DiamondItem.new(
      {
        category_code: "1",
        title: "RED SONJA #12 SECOND CVR"
      }).product_type?
  end

  def main_cvrs_check
    @_type ||= CbNitride::DiamondItem.new(
      {
        category_code: "1",
        title: "SOMETHING SOMETHING #20 MAIN CVRS"
      }).product_type?
  end

  def ideal_collection
    @_ideal_collection ||= CbNitride::DiamondItem.new(
      {
        category_code: "3",
        title: "BATTLING BOY HC GN"
      }).product_type?
  end

  def ideal_merchandise
    @_ideal_merchandise ||= CbNitride::DiamondItem.new(
      {
        category_code: "16",
        title: "ADV TIME MARCELINE NAME ONLY PX JRS RAGLAN LG (C: 0-1-0)"
      }).product_type?
  end

  def ideal_variant
    @_ideal_variant ||= CbNitride::DiamondItem.new(
      {
        category_code: "1",
        title: "SANDMAN OVERTURE #1 (OF 6) CVR B (MR)"
      }).product_type?
  end

  def ideal_issue
    @_ideal_issue ||= CbNitride::DiamondItem.new(
      {
        category_code: "1",
        title: "SANDMAN OVERTURE #1 (OF 6) CVR A (MR)"
      }).product_type?
  end

  def test_that_they_are_the_right_items
    assert_equal :issue, specific_issue
    assert_equal :issue, main_cvrs_check
    assert_equal :issue, ideal_issue
    assert_equal :variant, ideal_variant
    assert_equal :collection, ideal_collection
    assert_equal :merchandise, ideal_merchandise
  end

end
