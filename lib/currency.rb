require 'uri'
require 'net/http'
require 'openssl'
require 'json'

class Changer
  attr_reader :rate

  def initialize(from_type, to_type)
    from_type = from_type.to_s.upcase
    to_type = to_type.to_s.upcase
    url = URI("https://api.exchangeratesapi.io/latest?base=#{from_type}")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    request = Net::HTTP::Get.new(url)
    response = http.request(request)
    @rate = JSON.parse(response.read_body)["rates"]["#{to_type}"].to_f
  end
end
