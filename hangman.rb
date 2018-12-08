class Game
  def initialize
    @word = random_word
    @letter_display = "_ " * @word.length
    @incorrect_guesses = 0
    @incorrect_letters = []
    display
    round
  end

  private

  def random_word
    dictionary_words = File.open("dictionary.txt", "r").readlines.map { |word| word.strip.downcase }
    dictionary_words_between_5_12_chars = dictionary_words.select { |word| word.length >= 5 && word.length <= 12 }
    dictionary_words_between_5_12_chars[rand(0..dictionary_words.length)]
  end

  def prompt
    loop do
      puts("Enter a letter. You have #{7 - @incorrect_guesses} incorrect guesses left.")
      puts("Incorrect letters so far: #{@incorrect_letters.join(" ")}")
      @letter = gets.chomp.downcase
      if !(/^[a-z]{1}$/).match?(@letter)
        puts("Invalid input. Input a single letter only")
      else
        break
      end
    end
  end

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

Game.new



