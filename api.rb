require 'net/http'
require 'json'
require 'yaml'

class Api
  def initialize(text)
    config = YAML.load_file('config.yml')
    
    @text = text
    @url = "https://api.api-ninjas.com/v1/historicalevents?text="
    @api_key = config['api_key']
  end

  def get_history
    full_url = "#{@url}#{@text}"
    headers = {
      'Content-Type' => 'application/json',
      'X-Api-Key' => @api_key
    }

    url = URI.parse(full_url)

    # Create an HTTP object
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = (url.scheme == 'https') # Enable SSL if the URL uses HTTPS

    # Create a GET request with headers
    request = Net::HTTP::Get.new(url, headers)

    # Send the request and get the response
    response = http.request(request)

    # Check the response
    if response.is_a?(Net::HTTPSuccess)
      # Parse the JSON response
      data = JSON.parse(response.body)
      data
    else
      puts "HTTP request failed: #{response.code} - #{response.message}"
    end
  end
end