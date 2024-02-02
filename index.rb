require_relative 'api'
require "tty-prompt"

class ConsoleApp
  def initialize(data)
    @data = data
    @selected_index = nil
    @favorite_history = ""
  end

  def display_menu
    system('clear') || system('cls') # Clear the console screen
    prompt = TTY::Prompt.new
    @favorite_history = prompt.select("Choose your favorite history subject:", @data)
  end

  def call_api
    api = Api.new(@favorite_history)
    @data = api.get_history
  end

  def display_facts
    index = 0
    loop do
      event = @data[index]
      puts "#{event['month']}-#{event['day']}-#{event['year']}"
      puts "#{event['event']}"
      sleep 10
      index += 1
      break if index >= @data.length
    end
  end

  def run
    display_menu
    call_api
    display_facts
  end
end

# Example usage
data = ["Roman Empire", "World War II", "Revolutionary War"]
app = ConsoleApp.new(data)
app.run

