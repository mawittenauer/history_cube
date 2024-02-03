require_relative "api"
require "tty-prompt"
require "terminal-table"

def wrap_word(input_string, given_width = 40)
  array_of_characters = input_string.split("")
  output_string = []
  counter_variable = 0
  array_of_characters.each do |character|

  if character == "\n"
    counter_variable = 0

  elsif counter_variable >= given_width && character == " "
    character = "\n"
    counter_variable = 0
  end
    output_string << character
    counter_variable += 1
  end
  output_string.join("").to_s
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
      rows << ["#{event['month']}-#{event['day']}-#{event['year']}", "#{wrap_word(event['event'], 40)}"]
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

