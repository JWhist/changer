require 'minitest/autorun'
require_relative '../lib/currency'
require 'minitest/reporters'
Minitest::Reporters.use!

class CurrencyTest < MiniTest::Test
  def test_new_returns_currency_object
    bill = Currency.new(:usd, 3)
    assert_equal true, bill.is_a?(Currency)

    bill = Currency.new('usd', 3)
    assert_equal true, bill.is_a?(Currency)
  end

  def test_valid_types
    Currency::TYPES.each do |type|
      bill = Currency.new(type, 3)
      assert_equal true, bill.is_a?(Currency)
    end
  end

  def test_valid_amounts
    Currency::TYPES.each do |type|
      amount = rand(0.0..1000000.00)
      bill = Currency.new(type, amount)

      assert_equal true, bill.is_a?(Currency)
    end
  end

  def test_invalid_amount_reassignment
    bill = Currency.new(:usd, 5)
    invalid_values = ['', 'abc', nil, -23]
    invalid_values.each do |amount|
      assert_raises(ArgumentError) { bill.value = amount }
    end 
  end

  def test_invalid_types
    types = ['horse', :XXX, 123, nil, '', 'USD', :USD]
    amount = 1
    types.each do |type|
      assert_raises(ArgumentError) { Currency.new(type, amount) }
    end
  end

  def test_invalid_amounts
    amounts = ['', -123, nil, 'abc', :ABC]
    amounts.each do |amount|
      assert_raises(ArgumentError) do
        Currency.new(Currency::TYPES.sample, amount)
      end
    end
  end

  def test_fetch_rate_returns_float
    20.times do 
      from = Currency::TYPES.sample
      to = ''
      loop do 
        to = Currency::TYPES.sample
        break if to != from
      end
      rate = Currency.fetch_rate(from, to)
      assert_kind_of(Float, rate)
    end
  end

  def test_convert_method_returns_value
    20.times do
      from = Currency::TYPES.sample
      amount = rand(0.0..1000000.00)
      to = ''
      loop do 
        to = Currency::TYPES.sample
        break if to != from
      end
      start = Currency.new(from, amount)
      finish = start.convert(to)
      assert_kind_of(Currency, finish)
      assert_equal to, finish.type
    end
  end

  def test_to_s_method
      bill = Currency.new(:usd, 5.232576546)

      assert_equal "USD 5.23", bill.to_s
  end

  def test_to_f_method
    20.times do
      type = Currency::TYPES.sample
      amount = rand(0.0..1000000.00)

      bill = Currency.new(type, amount)

      assert_equal amount, bill.to_f
    end
  end

  def test_add_method_returns_caller_type
    first = Currency.new(:usd, 5)
    second = Currency.new(:cad, 5)
    sum = first + second

    assert_equal :usd, sum.type
  end

  def test_add_method_returns_float_value
    first = Currency.new(:usd, 5)
    second = Currency.new(:cad, 5)
    sum = first + second

    assert_kind_of(Float, sum.value)
  end

  def test_subtract_method_returns_caller_type
    first = Currency.new(:usd, 5)
    second = Currency.new(:cad, 5)
    sum = first - second

    assert_equal :usd, sum.type
  end

  def test_subtract_method_returns_float_value
    first = Currency.new(:usd, 5)
    second = Currency.new(:cad, 5)
    sum = first - second

    assert_kind_of(Float, sum.value)
  end
end
