require 'net/http'
require 'json'
require 'yaml'

class ConsoleApp
  def initialize(data)
    @data = data
    @selected_index = nil
  end

  def display_menu
    system('clear') || system('cls') # Clear the console screen

    puts "Select an option:"
    @data.each_with_index do |item, index|
      prefix = index == @selected_index ? '-> ' : '   '
      puts "#{prefix}#{index + 1}. #{item}"
    end
  end

  def select_item(index)
    @selected_index = index if index.between?(0, @data.length - 1)
  end

  def select_history
    input = gets.chomp.downcase
    case input
    when /^\d+$/
      index = input.to_i - 1
      if index.between?(0, @data.length - 1)
        select_item(index)
      else
        puts "Invalid selection. Please enter a valid number."
        sleep(1)
      end
    else
      puts "Invalid input. Please enter a number or 'q' to quit."
      sleep(1)
    end
  end

  def call_api
    config = YAML.load_file('config.yml')
    api_key = config['api_key']
    full_url = "https://api.api-ninjas.com/v1/historicalevents?text=#{@data[@selected_index]}"
    headers = {
      'Content-Type' => 'application/json',
      'X-Api-Key' => api_key
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
      puts "Response: #{data[0]['event']}"
    else
      puts "HTTP request failed: #{response.code} - #{response.message}"
    end
    puts "#{@data[@selected_index]} was selected"
  end

  def run
    display_menu
    select_history
    call_api
  end
end

# Example usage
data = ["Roman Empire", "World War II", "Revolutionary War"]
app = ConsoleApp.new(data)
app.run

