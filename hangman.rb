require 'yaml'

class Game
  def initialize()
    @word = random_word
    @incorrect_guesses = 0
    @incorrect_letters = []
    @letter_display = create_blank_display
  end

  def load_game
    if File.exists?("save_game.yml")
      saved_game = YAML.load(File.read("save_game.yml"))
      @word = saved_game[:word]
      @letter_display = saved_game[:letter_display]
      @incorrect_guesses = saved_game[:incorrect_guesses]
      @incorrect_letters = saved_game[:incorrect_letters]
    else
      puts("Cannot locate a game save file. Starting new game.")
    end
    play
  end

  def save_game_and_exit
    saved_game = YAML.dump ({
      :word => @word,
      :letter_display => @letter_display,
      :incorrect_guesses => @incorrect_guesses,
      :incorrect_letters => @incorrect_letters
    })
    File.open("save_game.yml", "w") { |file| file.puts(saved_game) }
    puts("Game saved. Exiting application.")
    exit
  end

  def play
    display
    round
  end

  private
  
  # Generates random word from dictionary file that is between 5 and 12 chars
  def random_word
    dictionary_words = File.open("dictionary.txt", "r").readlines.map { |word| word.strip.downcase }
    dictionary_words_between_5_12_chars = dictionary_words.select { |word| word.length >= 5 && word.length <= 12 }
    dictionary_words_between_5_12_chars[rand(0..dictionary_words_between_5_12_chars.length)]
  end

  def prompt
    loop do
      puts("Enter a letter. You have #{7 - @incorrect_guesses} incorrect guesses left. To save the game and exit please enter 'save game'.")
      puts("Incorrect letters so far: #{@incorrect_letters.join(" ")}")
      @letter = gets.chomp.downcase
      if @letter == "save game"
        save_game_and_exit
      elsif !(/^[a-z]{1}$/).match?(@letter)
        puts("Invalid input. Input a single letter only")
      else
        break
      end
    end
  end

  #
  def round
    until win? || lose?
      prompt
      if @word.include?(@letter)
        match_indexes = (0 ... @word.length).find_all { |i| @word[i,1] == @letter }
        match_indexes.each { |m| @letter_display[m * 2] = @letter }
      else
        puts("Incorrect guess!")
        @incorrect_guesses += 1
        @incorrect_letters << @letter
      end
      display
      win_or_lose
    end
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
    display = "       _____\n      |     #{stick_hangman[0]}\n      |     #{stick_hangman[1]}\n      |    #{stick_hangman[2]}#{stick_hangman[3]}#{stick_hangman[4]}\n      |    #{stick_hangman[5]} #{stick_hangman[6]}\n______|______"
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

  def win?
    !@letter_display.include?("_")
  end
  
  def lose?
    @incorrect_guesses == 7
  end

  def win_or_lose
    if win?
      puts("YOU WIN!")
    elsif lose?
      puts("GAME OVER. YOU LOSE! The correct answer was #{@word}.")
    end
  end
end



puts("Would you like to load an existing game or start a new game? Enter 'load' or 'new':")
case gets.chomp
when 'new'
  Game.new.play
when 'load' 
  Game.new.load_game
else
  puts("Incorrect command. Exiting application.")
end



