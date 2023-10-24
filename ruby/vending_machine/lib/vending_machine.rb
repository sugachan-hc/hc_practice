# frozen_string_literal: true

require_relative 'juice'

# This represent a VendingMachine class.
class VendingMachine
  attr_reader :juices, :stocks, :sales

  def initialize
    @juices = [
      Juice.new('ペプシ', 150),
      Juice.new('モンスター', 230),
      Juice.new('いろはす', 120)
    ]
    @stocks = [5, 5, 5]
    @sales = 0
  end

  def index_of_juice(name)
    @juices.index { |juice| juice.name == name }
  end

  def stock(name)
    index = index_of_juice(name)
    return nil if index.nil?

    @stocks[index]
  end

  def purchaseable?(name, suica)
    index = index_of_juice(name)
    return false if index.nil?

    @stocks[index].positive? && suica.balance >= @juices[index].price
  end

  def validate_purchase(index, suica)
    raise ArgumentError, 'Not Available.' if index.nil?
    raise ArgumentError, 'Out of Stock.' if @stocks[index].zero?
    raise ArgumentError, 'Insufficient Balance. Recharge!' if suica.balance < @juices[index].price
  end

  def purchase(name, suica)
    index = index_of_juice(name)

    validate_purchase(index, suica)

    @stocks[index] -= 1
    @sales += @juices[index].price
    suica.pay(@juices[index].price)

    suica.balance
  end

  def available_drinks(suica)
    available_drinks = []

    @juices.each_with_index do |juice, index|
      available_drinks << juice.name if @stocks[index].positive? && suica.balance >= juice.price
    end

    available_drinks
  end

  def restock(name, quantity)
    index = index_of_juice(name)
    return nil if index.nil?

    @stocks[index] += quantity
  end
end
