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

    puts "Press 'q' to quit."
  end

  def select_item(index)
    @selected_index = index if index.between?(0, @data.length - 1)
  end

  def run
    loop do
      display_menu
      input = gets.chomp.downcase

      case input
      when 'q'
        break
      when /\A\d+\z/
        select_item(input.to_i - 1)
      else
        puts "Invalid input. Please enter a number or 'q' to quit."
        sleep(1)
      end
    end
  end
end

# Example usage
data = ["Roman History", "United States History", "Greek History"]
app = ConsoleApp.new(data)
app.run

