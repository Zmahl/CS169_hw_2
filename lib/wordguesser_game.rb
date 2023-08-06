class WordGuesserGame

  # add the necessary class methods, attributes, etc. here
  # to make the tests in spec/wordguesser_game_spec.rb pass.
  attr_reader :word
  attr_accessor :guesses
  attr_accessor :wrong_guesses

  @@MAX_GUESSES = 7

  # Get a word from remote "random word" service

  def initialize(word)
    @word = word
    @guesses = ""
    @wrong_guesses = ""
    @letters_guessed = {}
    
  end

  # You can test it by installing irb via $ gem install irb
  # and then running $ irb -I. -r app.rb
  # And then in the irb: irb(main):001:0> WordGuesserGame.get_random_word
  #  => "cooking"   <-- some random word
  def self.get_random_word
    require 'uri'
    require 'net/http'
    uri = URI('http://randomword.saasbook.info/RandomWord')
    Net::HTTP.new('randomword.saasbook.info').start { |http|
      return http.post(uri, "").body
    }
  end
  
  def guess char
    
    validate_guess char
    
    char.downcase!
    
    if (not was_guessed? char)
      if @word.include? char
        @guesses += char
      else
        @wrong_guesses += char
      end
      
      @letters_guessed[char] = 1
      
    else
      false
    end
  end
  
  def word_with_guesses
    displayed_string = ''
    for letter in @word.split('')
      if @guesses.include? letter
        displayed_string += letter
      
      else
        displayed_string += '-'
      end
    end

    displayed_string
  end
  
  def check_win_or_lose
    
    if word_with_guesses == @word
     return :win
     
    elsif @letters_guessed.length >= @@MAX_GUESSES
        return :lose
     
    else return :play
    end
  end 
  
  private
    def was_guessed? char
      return @letters_guessed.key?(char)
    end
    
    def validate_guess char
      if char.nil? || char.empty? || !char.match?(/[a-zA-Z]/)
        raise ArgumentError
      end
    end
end
