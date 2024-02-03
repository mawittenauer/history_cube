module Helper
  def self.wrap_word(input_string, given_width = 40)
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
end
