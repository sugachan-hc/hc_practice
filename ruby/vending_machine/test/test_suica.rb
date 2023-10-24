# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/suica'

# This represent a Test Suica class.
class TestSuica < Minitest::Test
  # 毎回実行する処理
  def setup
    @suica = Suica.new
  end

  # 預かり金(デポジット)として500円がデフォルトでチャージされているか？
  def test_default_deposit
    assert_equal 500, @suica.balance
  end

  # Suicaには100円以上の任意の金額をチャージできるか？
  def test_charge_valid_amount
    amount = 100
    @suica.charge(amount)
    assert_equal 500 + amount, @suica.balance
  end

  # 100円未満をチャージしようとした場合は例外を発生させる
  def test_charge_invalid_amount
    invalid_amount = 50
    assert_raises(ArgumentError, 'Please charge at least 100 yen.') do
      @suica.charge(invalid_amount)
    end
  end

  # Suicaは現在のチャージ残高を取得できる
  def test_get_current_balance
    assert_equal 500, @suica.balance
  end

  # Suicaの残高は外部から書き換えられない
  def test_balance_cannot_be_modified_from_outside
    assert_raises(NoMethodError) { @suica.balance = 500 }
  end
end
