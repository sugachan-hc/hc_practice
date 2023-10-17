# frozen_string_literal: true

require 'minitest/autorun'
require_relative '../lib/suica'
require_relative '../lib/vending_machine'

# This represent a Test VendingMachine class.
class TestVendingMachine < Minitest::Test
  # 毎回実行する処理
  def setup
    @suica = Suica.new
    @vending_machine = VendingMachine.new
  end

  # 自動販売機はジュースを１種類格納できる => 仕様拡張により3種類へ変更(test_manage_juicesでテスト)

  # ジュースは名前と値段の情報をもつ => test_juice.rbでテスト

  # 初期状態で、ペプシ(150円)を5本格納している。
  def test_initial_stock
    assert_equal 5, @vending_machine.stock('ペプシ')
  end

  # 自動販売機は在庫を取得できる
  def test_get_stocks
    assert_equal [5, 5, 5], @vending_machine.stocks
  end

  # 自動販売機はペプシが購入できるかどうかを取得できる
  def test_can_purchase_pepsi
    assert_equal true, @vending_machine.purchaseable?('ペプシ', @suica)
  end

  # ステップ3と同様の方法でモンスターといろはすを購入できる > 「モンスター」 の場合
  def test_can_purchase_monster
    assert_equal true, @vending_machine.purchaseable?('モンスター', @suica)
  end

  # ステップ3と同様の方法でモンスターといろはすを購入できる > 「いろはす」 の場合
  def test_can_purchase_ilohas
    assert_equal true, @vending_machine.purchaseable?('いろはす', @suica)
  end

  # ジュース値段以上のチャージ残高がある条件下で購入操作を行うと以下の動作をする
  # - 自動販売機はジュースの在庫を減らす
  # - 売り上げ金額を増やす
  # - Suicaのチャージ残高を減らす
  def test_purchase_operation
    # 購入前の状態
    assert_equal 5, @vending_machine.stock('ペプシ')
    assert_equal 0, @vending_machine.sales
    assert_equal 500, @suica.balance

    # ペプシを購入する
    @vending_machine.purchase('ペプシ', @suica)

    # 購入後の状態
    assert_equal 4, @vending_machine.stock('ペプシ')
    assert_equal 150, @vending_machine.sales
    assert_equal 350, @suica.balance
  end

  # チャージ残高が足りない場合..(略)..購入操作を行った場合は例外を発生させる
  def test_insufficient_balance
    3.times { @vending_machine.purchase('ペプシ', @suica) } # (150円 * 3本)分の料金を使う

    assert_raises(ArgumentError, 'Insufficient Balance. Recharge!') do
      @vending_machine.purchase('モンスター', @suica)
    end
  end

  # (略)..もしくは在庫がない場合、購入操作を行った場合は例外を発生させる
  def test_out_of_stock
    amount = 750 # (150円 * 5本)分の料金をチャージ
    @suica.charge(amount)
    5.times { @vending_machine.purchase('ペプシ', @suica) } # 在庫分全部買占める

    assert_raises(ArgumentError, 'Out of Stock.') do
      @vending_machine.purchase('ペプシ', @suica)
    end
  end

  # 自動販売機は現在の売上金額を取得できる
  def test_get_sales
    # 初期状態の売り上げは0円であることを確認
    assert_equal 0, @vending_machine.sales

    # ペプシを1本(150円)、購入して売上金額が正しく更新されることを確認
    @vending_machine.purchase('ペプシ', @suica)
    assert_equal 150, @vending_machine.sales

    # モンスターを1本(230円)購入して売上金額が正しく更新されることを確認
    @vending_machine.purchase('モンスター', @suica)
    assert_equal 380, @vending_machine.sales

    # いろはすを1本(120円)購入して売上金額が正しく更新されることを確認
    @vending_machine.purchase('いろはす', @suica)
    assert_equal 500, @vending_machine.sales
  end

  # ジュースを3種類管理できるようにする。
  # - 初期状態で、ペプシ(150円)を5本格納している。
  # - 初期在庫にモンスター(230円)5本を追加する。
  # - 初期在庫にいろはす(120円)5本を追加する。
  def test_manage_juices
    # 初期状態で3種類のジュースが登録されていることを確認
    assert_equal 3, @vending_machine.juices.size

    # 初期状態でペプシ、モンスター、いろはすがそれぞれ5本ずつ格納されていることを確認
    assert_equal 5, @vending_machine.stock('ペプシ')
    assert_equal 5, @vending_machine.stock('モンスター')
    assert_equal 5, @vending_machine.stock('いろはす')
  end

  # 自動販売機は購入可能なドリンクのリストを取得できる > Sica残高で購入可能なドリンクのリストを取得する
  def test_suica_has_enough_balance_for_drink
    # 初期状態でのテスト
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal %w[ペプシ モンスター いろはす], available_drinks

    # ペプシを1本(150円)購入した後のテスト（Suica残高500->350）
    @vending_machine.purchase('ペプシ', @suica)
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal %w[ペプシ モンスター いろはす], available_drinks

    # モンスターを1本(230円)購入した後のテスト（Suica残高350->120）
    @vending_machine.purchase('モンスター', @suica)
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal %w[いろはす], available_drinks

    # いろはすを1本(120円)購入した後のテスト（Suica残高120->0）
    @vending_machine.purchase('いろはす', @suica)
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal [], available_drinks
  end

  # 自動販売機は購入可能なドリンクのリストを取得できる > 在庫があるドリンクのリストを取得する
  def test_available_drinks_with_stock
    amount = 2500 # ペプシ(150円x5本)、モンスター(230円x5本)いろはす(120円x5本)分の料金を事前にチャージ
    @suica.charge(amount)

    # 初期状態でのテスト
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal %w[ペプシ モンスター いろはす], available_drinks

    # ペプシ在庫切れ
    5.times { @vending_machine.purchase('ペプシ', @suica) }
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal %w[モンスター いろはす], available_drinks

    # モンスター在庫切れ
    5.times { @vending_machine.purchase('モンスター', @suica) }
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal %w[いろはす], available_drinks

    # いろはす在庫切れ
    5.times { @vending_machine.purchase('いろはす', @suica) }
    available_drinks = @vending_machine.available_drinks(@suica)
    assert_equal [], available_drinks
  end

  # 自動販売機に在庫を補充できるようにする
  def test_restock
    # 初期状態でのテスト。ペプシを代表例としてテスト
    initial_stock = @vending_machine.stock('ペプシ')
    assert_equal 5, initial_stock

    # ペプシの在庫を追加して6本にする
    @vending_machine.restock('ペプシ', 1)
    increased_stock = @vending_machine.stock('ペプシ')
    assert_equal 6, increased_stock
  end

  # 売上金額は外部から書き換えられない
  def test_sales_cannot_be_modified_from_outside
    assert_raises(NoMethodError) { @vending_machine.sales = 0 }
  end
end
