require_relative '../test_helper'

class PrivateHasherTest < MiniTest::Unit::TestCase
  include LoginInformation
  include Recordable
  include CategoryCodes
  include HasherTests

  def setup_object(code)
    setup_vcr
    @item = CbNitride::PrivateHasher.item(code)
    clear_vcr
  end

  def setup
    set_login_data
  end

  def teardown
    clear_login_data
  end

  def test_that_the_private_hash_produces_a_diamond_item
    setup_object(ISSUE_CODE)
    assert_equal @item.class, CbNitride::DiamondItem
  end

  def test_that_the_private_diamond_item_contains_the_right_fields
    setup_object(ISSUE_CODE)
    refute_equal @item.title, "Pug Party Parade"
    assert_equal @item.stock_number, "STK611169"
    assert_equal @item.diamond_number, ISSUE_CODE
    assert_equal @item.image_url, "https://retailerservices.diamondcomics.com/Image/Display?pd=webdata/catalogimages/STK_IMAGES_THUMBNAIL/STK600001-620000&pf=STK611169_TN.jpg"
    assert_equal @item.publisher, "DC COMICS"
    assert_equal @item.creators, "(W) Jeff Lemire (A/CA) Andrea Sorrentino"
    assert_equal @item.description, "Ollie returns to the island where he first became Green Arrow and learns some hard truths about his father and the mysterious Outsiders!"
    assert_equal @item.release_date.to_s, "2013-06-05"
    assert_equal @item.price, 2.99
    assert_equal @item.state, :private
    assert_equal @item.category_code, "1"
  end

  def test_that_the_private_hash_identifies_issues
    setup_object(ISSUE_CODE)
    assert_equal @item.category_code, ISSUE_CATEGORY_CODE
  end

  def test_that_the_private_hash_identifies_variants
    setup_object(VARIANT_CODE)
    assert_equal @item.category_code, ISSUE_CATEGORY_CODE
  end

  def test_that_the_private_hash_identifies_merchandise
    setup_object(MERCH_CODE)
    assert_includes MERCHANDISE_CATEGORY_CODES, @item.category_code
  end

  def test_that_the_private_hash_identifies_collection
    setup_object(COLLECTION_CODE)
    assert_equal @item.category_code, COLLECTION_CATEGORY_CODE
  end

  def test_that_the_private_hash_identifies_invalid_diamond_codes
    assert_raises CbNitride::InvalidDiamondNumberError do
      setup_object("FEB1099999")
    end
  end
end
