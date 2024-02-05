require_relative "api"
require_relative "helper"
require "tty-prompt"
require "terminal-table"

class ConsoleApp
  def initialize(menu_selections)
    @menu_selections = menu_selections
    @facts = []
    @selected_index = nil
    @favorite_history = ""
  end

  def display_menu
    system('clear') || system('cls') # Clear the console screen
    prompt = TTY::Prompt.new
    @favorite_history = prompt.select("Choose your favorite history subject:", @menu_selections)
  end

  def call_api
    api = Api.new(@favorite_history)
    @facts = api.get_history[0..2]
  end

  def display_facts
    index = 0
    loop do
      system('clear') || system('cls')
      event = @facts[index]
      rows = []
      rows << ["#{event['month']}-#{event['day']}-#{event['year']}", "#{Helper.wrap_word(event['event'], 40)}"]
      table = Terminal::Table.new(:title => "History Facts", :headings => ['Date', 'Event'], :rows => rows)
      puts table
      sleep 10
      index += 1
      break if index >= @facts.length
    end
  end

  def run
    loop do
      display_menu
      call_api
      display_facts
    end
  end
end

# Example usage
menu_selections = ["Roman Empire", "World War II", "Revolutionary War"]
app = ConsoleApp.new(menu_selections)
app.run
