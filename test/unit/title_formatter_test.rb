require_relative '../test_helper'

class CbNitride::TitleFormatterTest < MiniTest::Unit::TestCase

  def issue
    @_issue ||= CbNitride::TitleFormatter.new('GREEN LANTERN #17')
  end

  def variant
    @_variant ||= CbNitride::TitleFormatter.new('GREEN LANTERN #17 CVR B ZAYAS')
  end

  def unclean
    @_unclean ||= CbNitride::TitleFormatter.new('GREEN LANTERN #17 (MR) (NET) (C: 1-0-1)')
  end

  def special_number
    @_special_number ||= CbNitride::TitleFormatter.new('AGE OF ULTRON #10AI CVR B')
  end

  def limited_series
    @_limited_series ||= CbNitride::TitleFormatter.new('GREEN LANTERN: EMERALD KNIGHTS #4 (OF 6) B CVR')
  end

  def test_clean_string
    assert_equal "GREEN LANTERN #17", unclean.clean_title
  end

  def test_issue_number
    assert_equal 17, issue.issue_number
    assert_equal 17, variant.issue_number
    assert_equal 10, special_number.issue_number
    assert_equal 4, limited_series.issue_number
  end

  def test_special_number
    assert_equal '17', issue.special_number
    assert_equal '17', variant.special_number
    assert_equal '10AI', special_number.special_number
    assert_equal '4', limited_series.special_number
  end

  def test_limited_series_max_issue
    assert_equal nil, issue.limited_series_max_issue
    assert_equal nil, variant.limited_series_max_issue
    assert_equal nil, special_number.limited_series_max_issue
    assert_equal 6, limited_series.limited_series_max_issue
  end

  def test_variant_description
    assert_equal nil, issue.variant_description
    assert_equal "CVR B ZAYAS", variant.variant_description
    assert_equal "CVR B", special_number.variant_description
    assert_equal "B CVR", limited_series.variant_description
  end

  def series_title
    assert_equal "GREEN LANTERN", issue.series_title
    assert_equal "GREEN LANTERN", variant.series_title
    assert_equal "AGE OF ULTRON", special_number.series_title
    assert_equal "GREEN LANTERN: EMERALD KNIGHTS", limited_series.series_title
  end
end
