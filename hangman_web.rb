

class Game
  attr_accessor :word, :incorrect_guesses, :incorrect_letters, :letter_display
  def initialize()
    @word = random_word
    @incorrect_guesses = 0
    @incorrect_letters = []
    @letter_display = "_ " * @word.length
  end
  
  # Generates random word from dictionary file that is between 5 and 12 chars
  def random_word
    dictionary_words = File.open("dictionary.txt", "r").readlines.map { |word| word.strip.downcase }
    dictionary_words_between_5_12_chars = dictionary_words.select { |word| word.length >= 5 && word.length <= 12 && word != "" }
    dictionary_words_between_5_12_chars[rand(0..dictionary_words_between_5_12_chars.length)]
  end

  def enter_letter(letter)
    return if letter == nil
    return if @incorrect_guesses == 7
    @letter = letter.downcase
    if !(/^[a-z]{1}$/).match?(@letter)
      "Invalid input. Input a single letter only"
    else
      round
    end
  end

  
  def round    
    if @word.include?(@letter)
      match_indexes = (0 ... @word.length).find_all { |i| @word[i,1] == @letter }
      match_indexes.each { |m| @letter_display[m * 2] = @letter }
    else
      puts("Incorrect guess!")
      @incorrect_guesses += 1
      @incorrect_letters << @letter
    end 
    win_or_lose
  end

  def display_hangman
    case @incorrect_guesses
    when 0 
      stick_hangman = ["", "", "", "", "", "", ""]
    when 1
      stick_hangman = ["|", "", "", "", "", "", ""]
    when 2
      stick_hangman = ["|", "0", "", "", "", "", ""]
    when 3
      stick_hangman = ["|", "0", "/", "", "", "", ""]
    when 4
      stick_hangman = ["|", "0", "/", "|", "", "", ""]
    when 5
      stick_hangman = ["|", "0", "/", "|", "\\", "", ""]
    when 6
      stick_hangman = ["|", "0", "/", "|", "\\", "/", ""]
    when 7
      stick_hangman = ["|", "0", "/", "|", "\\", "/", "\\"]
    end
 
   
    "       _____\n"\
    "      |     #{stick_hangman[0]}\n"\
    "      |     #{stick_hangman[1]}\n"\
    "      |    #{stick_hangman[2]}#{stick_hangman[3]}#{stick_hangman[4]}\n"\
    "      |    #{stick_hangman[5]} #{stick_hangman[6]}\n"\
    "______|______\n"\
  end

  # Generates the string of blanks e.g; if the word was 'testing' this method will generate a string: "_ _ _ _ _ _ _ "
  def create_blank_display
    "_ " * @word.length
  end

  def display
    puts display_hangman
    puts
    puts @letter_display
  end

  def display_letters
    @letter_display
  end

  def win?
    !@letter_display.include?("_")
  end
  
  def lose?
    @incorrect_guesses == 7
  end

  def win_or_lose
    if win?
      ("YOU WIN!")
    elsif lose?
      ("GAME OVER. YOU LOSE! \nThe correct answer was #{@word}.")
    end
  end
end
