require_relative "api"
require "tty-prompt"
require "terminal-table"

def add_line_breaks(input_string, break_length)
  input_string.scan(/.{1,#{break_length}}/).join("\n")
end

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
      system('clear') || system('cls')
      event = @data[index]
      rows = []
      rows << ["#{event['month']}-#{event['day']}-#{event['year']}", "#{add_line_breaks(event['event'], 40)}"]
      table = Terminal::Table.new(:title => "History Facts", :headings => ['Date', 'Event'], :rows => rows)
      puts table
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

