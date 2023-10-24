# frozen_string_literal: true

# This represent a Juice class.
class Juice
  attr_reader :name, :price

  def initialize(name, price)
    @name = name
    @price = price
  end
end
