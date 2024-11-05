# app/services/alpha_vantage_api.rb
require 'uri'
require 'net/http'
require 'json'

class AlphaVantageApi
  BASE_URL = "https://alpha-vantage.p.rapidapi.com/query".freeze

  def initialize(api_key)
    @api_key = api_key
  end

  def symbol_search(keywords)
    url = URI("#{BASE_URL}?datatype=json&keywords=#{URI.encode_www_form_component(keywords)}&function=SYMBOL_SEARCH")
    make_request(url)
  end

  def time_series_intraday(symbol, interval = '5min', output_size = 'compact')
    url = URI("#{BASE_URL}?datatype=json&function=TIME_SERIES_INTRADAY&symbol=#{URI.encode_www_form_component(symbol)}&interval=#{interval}&outputsize=#{output_size}")
    make_request(url)
  end

  private

  def make_request(url)
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request["x-rapidapi-key"] = @api_key
    request["x-rapidapi-host"] = 'alpha-vantage.p.rapidapi.com'

    response = http.request(request)
    JSON.parse(response.body)
  rescue JSON::ParserError
    { error: "Failed to parse response" }
  rescue StandardError => e
    { error: e.message }
  end
end
