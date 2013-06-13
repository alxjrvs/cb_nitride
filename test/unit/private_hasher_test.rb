require_relative '../test_helper'

class PrivateHasherTest < MiniTest::Unit::TestCase
  include LoginInformation
  include Recordable
  include HasherTests

  def setup_object(code)
    setup_vcr
    @hash = CbNitride::PrivateHasher.item(code)
    clear_vcr
  end

  def setup
    set_login_data
  end

  def teardown
    clear_login_data
  end

  def test_that_the_private_hash_contains_the_right_fields
    setup_object(ISSUE_CODE)

    refute_equal @hash[:issue][:title], "Pug Party Parade"
    assert_equal @hash[:issue][:stock_number], "STK611169"
    assert_equal @hash[:issue][:diamond_number], ISSUE_CODE
    assert_equal @hash[:issue][:image_url], "https://retailerservices.diamondcomics.com/Image/Display?pd=webdata/catalogimages/STK_IMAGES_THUMBNAIL/STK600001-620000&pf=STK611169_TN.jpg"
    assert_equal @hash[:issue][:publisher], "DC COMICS"
    assert_equal @hash[:issue][:creators], "(W) Jeff Lemire (A/CA) Andrea Sorrentino"
    assert_equal @hash[:issue][:description], "Ollie returns to the island where he first became Green Arrow and learns some hard truths about his father and the mysterious Outsiders!"
    assert_equal @hash[:issue][:release_date].to_s, "2013-06-05"
    assert_equal @hash[:issue][:price], 2.99
    assert_equal @hash[:type], :private
  end

  def test_that_the_private_hash_identifies_issues
    setup_object(ISSUE_CODE)
    assert_it_is_a :issue
  end

  def test_that_the_private_hash_identifies_variants
    setup_object(VARIANT_CODE)
    assert_it_is_a :variant
  end

  def test_that_the_private_hash_identifies_merchandise
    setup_object(MERCH_CODE)
    assert_it_is_a :merchandise
  end

  def test_that_the_private_hash_identifies_collection
    setup_object(COLLECTION_CODE)
    assert_it_is_a :collection
  end

  def test_that_the_private_hash_identifies_invalid_diamond_codes
    setup_object("FEB1099999")
    assert_equal @hash, {}
  end

end
