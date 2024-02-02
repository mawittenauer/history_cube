require_relative 'api'

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
    api = Api.new(@data[@selected_index])
    puts api.get_history
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

