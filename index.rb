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
    puts api.get_history
  end

  def run
    display_menu
    call_api
  end
end

# Example usage
data = ["Roman Empire", "World War II", "Revolutionary War"]
app = ConsoleApp.new(data)
app.run

