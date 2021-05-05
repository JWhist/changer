require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class Changer
  attr_reader :rate

  def initialize(from_type, to_type)
    from_type = from_type.to_s.upcase
    to_type = to_type.to_s.upcase
    url = URI("https://currency-exchange.p.rapidapi.com/exchange?to=#{to_type}&from=#{from_type}&q=1.0")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    
    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = ENV['RAPID_API_KEY']
    request["x-rapidapi-host"] = 'currency-exchange.p.rapidapi.com'
    
    response = http.request(request)
    @rate = JSON.parse(response.read_body).to_f
  end
end
