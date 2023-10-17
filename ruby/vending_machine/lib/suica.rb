# frozen_string_literal: true

# This represent a Suica class.
class Suica
  attr_reader :balance

  def initialize
    @deposit = 500
    @balance = @deposit
  end

  def charge(amount)
    raise ArgumentError, 'Please charge at least 100 yen.' if amount < 100

    @balance += amount
  end

  def pay(amount)
    raise ArgumentError, 'Insufficient Balance.' if amount > @balance

    @balance -= amount
  end
end
