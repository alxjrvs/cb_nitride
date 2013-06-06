require_relative '../test_helper'

class PublicHasherTest < MiniTest::Unit::TestCase
  include Recordable

  ISSUE_CODE = "APR130131"
  VARIANT_CODE = "APR130183"
  MERCH_CODE = "MAR131699"
  COLLECTION_CODE = "FEB130068"

  def setup_object(code)
    setup_vcr

    @public_hasher = CbNitride::PublicHasher.item(code)

    clear_vcr
  end

  def test_that_it_grabs_the_right_field
    setup_object(ISSUE_CODE)
  end
end
