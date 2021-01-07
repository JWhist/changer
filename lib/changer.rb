require_relative 'currency'
class Currency
  attr_accessor :value
  attr_reader :type
  TYPES = [:usd, :eur, :jpy, :gbp, :aud, :cad, :cny, :hkd, :nzd, :chf]
  # Create a new Currency object
  #
  #
  # @param to_type [Symbol]
  # @param amount [Numeric]
  # @return [Currency]
  def initialize(to_type, amount)
    raise ArgumentError.new("Invalid type or value") unless verify_valid?(to_type, amount)

    @type = to_type
    @value = format_value(amount)
  end
  # Manually set a new value for a Currency object
  # @param amount [Numeric]
  def value=(amount)
    raise ArgumentError.new("Amount must be a non-negative numeric value") unless amount.is_a?(Numeric) && amount >= 0 

    @value = amount.to_f
  end
  # Convert a currency to another type using market rates
  # @param to_type [Symbol]
  # @return [Currency] || nil if invalid
  def convert(to_type)
    return nil unless TYPES.include?(to_type) 

    new_value = value * Currency.fetch_rate(type, to_type)
    Currency.new(to_type, new_value) 
  end
  # Convert to a different currency at a specified rate
  # @param to_type [Symbol]
  # @param rate [Numeric]
  # @note rate is set based on the calling object as a base
  def convert_at(to_type, rate)
    return nil unless TYPES.include?(to_type)

    new_value = value * rate
    Currency.new(to_type, new_value)
  end
  # Convert the calling object to the currency specified by the to_type param
  # @param to_type [Symbol]
  def convert!(to_type)
    return nil unless TYPES.include?(to_type) 

    self.value = value * Currency.fetch_rate(type, to_type)
    @type = to_type
    self
  end
  # Convert the calling object to the currency specified by the to_type param
  # at the rate specified by the rate parameter
  # @param rate [Numeric]
  def convert_at!(to_type, rate)
    return nil unless TYPES.include?(to_type)

    self.value = value * rate
    @type = to_type  
    self
  end
  # Return the current value of the Currency object
  # @return [Numeric]
  def to_f
    value
  end
  # Return a string formatted as ie; "USD 5.00"
  # @return [String] 
  def to_s
    format_string
  end

  # All of the math operations return values in the type of currency 
  # calling the method ie: USD + GBP = USD, but GBP + USD = GBP
  def +(other)
    first_type = self.type
    new_value = (value + other.convert(first_type).value)
    Currency.new(first_type, new_value)
  end

  def -(other)
    first_type = self.type
    new_value = (value - other.convert(first_type).value)
    Currency.new(first_type, new_value)
  end

  def *(other)
    first_type = self.type
    new_value = (value * other.convert(first_type).value)
    Currency.new(first_type, new_value)
  end

  def /(other)
    first_type = self.type
    new_value = (value / other.convert(first_type).value)
    Currency.new(first_type, new_value)
  end
  # Fetch the current exchange rate using the from_type as the base
  # @param from_type [Symbol]
  # @param to_type [Symbol]
  def self.fetch_rate(from_type, to_type)
    changer = Changer.new(from_type, to_type)
    changer.rate
  end

  private

  def format_string
    amount = add_commas(format("%.2f",value))
    "#{type.to_s.upcase} #{amount}"
  end

  def format_value(value)
    value.to_f
  end

  def verify_valid?(to_type, amount)
    return false unless amount.is_a?(Numeric) && to_type.is_a?(Symbol)

    amount >= 0.0 && TYPES.include?(to_type)
  end

  def add_commas(number)
    first, last = number.to_s.split('.')
    first.reverse.chars.each_slice(3).to_a
         .map(&:join).join(',').reverse + '.' + last
  end
end
