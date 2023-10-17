# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/juice'

# This represent a Test Juice class.
class TestJuice < Minitest::Test
  # 毎回実行する処理
  def setup
    @juice = Juice.new('ペプシ', 150)
  end

  # ジュースは名前と値段の情報をもつ > 名前を持つことを確認
  def test_name
    assert_equal 'ペプシ', @juice.name
  end

  # ジュースは名前と値段の情報をもつ > 値段を持つことを確認
  def test_price
    assert_equal 150, @juice.price
  end
end
