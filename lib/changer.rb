require_relative 'currency'
class Currency
  attr_accessor :type, :value
  TYPES = [:usd, :eur, :jpy, :gbp, :aud, :cad, :cnh, :hkd, :nzd, :chf]

  def initialize(to_type, value)
    raise ArgumentError.new("Invalid type or value") unless verify_valid?(to_type, value)

    @type = to_type
    @value = format_value(value)
  end

  def convert(to_type)
    return nil unless TYPES.include?(to_type) 

    new_value = value * fetch_rate(type, to_type)
    Currency.new(to_type, new_value) 
  end

  def convert_at(to_type, rate)
    return nil unless TYPES.include?(to_type)

    new_value = value * rate
    Currency.new(to_type, new_value)
  end

  def convert!(to_type)
    return nil unless TYPES.include?(to_type) 

    self.value = value * fetch_rate(type, to_type)
    self.type = to_type
    self
  end

  def convert_at!(to_type, rate)
    return nil unless TYPES.include?(to_type)

    self.value = value * rate
    self.type = to_type  
    self
  end

  def to_f
    value
  end
  
  def to_s
    format_string
  end

  # All of the math operations return values in the type of currency 
  # calling the method ie: USD + GBP = USD, but GBP + USD = GBP
  def +(other)
    first_type = self.type
    new_value = (value + other.convert(first_type).value).round(2)
    Currency.new(first_type, new_value)
  end

  def -(other)
    first_type = self.type
    new_value = (value - other.convert(first_type).value).round(2)
    Currency.new(first_type, new_value)
  end

  def *(other)
    first_type = self.type
    new_value = (value * other.convert(first_type).value).round(2)
    Currency.new(first_type, new_value)
  end

  def /(other)
    first_type = self.type
    new_value = (value / other.convert(first_type).value).round(2)
    Currency.new(first_type, new_value)
  end

  private

  def format_string
    amount = add_commas(format("%.2f",value))
    "#{type.to_s.upcase} #{amount}"
  end

  def format_value(value)
    value.to_f.truncate(2)
  end

  def verify_valid?(to_type, value)
    value >= 0.0 && value < 1_000_000_000_000 && TYPES.include?(to_type)
  end

  def fetch_rate(from_type, to_type)
    changer = Changer.new(from_type, to_type)
    changer.rate
  end

  def add_commas(number)
    first, last = number.to_s.split('.')
    first.reverse.chars.each_slice(3).to_a
         .map(&:join).join(',').reverse + '.' + last
  end
end
