require 'pry-byebug'

class Selector
  attr_accessor :selected_array, :player_array

  def initialize
    p 'What is your name?'
    @name = gets.chomp
    Player.new(@name.to_s)
    rules
    Computer.new
    p 'Do you want to make the code or break the code?'
    @answer = gets.chomp
    if @answer.downcase == 'make'
      Computer.player_game
    else
      Player.player_game
    end
  end

  def winner
    @@win_con = true
  end

  def rules
    p 'Do you know how to play? (Y/N)'
    answer = gets.chomp
    return unless answer.downcase == 'n'

    rules_text
  end

  def rules_text
    p 'This is a code-breaker game, in here you will have to select from valid colours and try to crack the code'
    p 'You will have four rounds to crack the code'
    p 'After each round, you will see the result of your guessing.'
    p "If you get a '●' it means you've got the right colour on the right spot"
    p "If you get a '◑' it means you've got the right colour on the wrong spot, and that the colour should go to the right"
    p "If you get a '◐' it means you've got the right colour on the wrong spot, and that the colour should go to the left"
    p "If you get a '○' it means you've got a wrong colour"
    p 'good luck'
  end

  class Player
    attr_accessor :name, :win_con

    def initialize(name)
      @name = name
      @@player_game = true
      @@win_con = false
      @selected_array = []
      @player_array = []
    end

    attr_reader :name

    def self.player_game
      @@player_game = true
      random
      turn
    end

    def self.turn
      until @@win_con == true
        4.times do
          choose
          checker
        end
        @@win_con = true
        p 'You Lost!'

      end
    end

    def self.random
      @colors_array = %w[green blue pink red black white]
      computer_array = []
      until computer_array.length == 4
        i = rand(0..5)
        computer_array << @colors_array[i]

      end
      if @@player_game == true
        @selected_array = computer_array
      else
        @player_array = computer_array
      end
    end

    def self.choose
      @chooser_array = []

      until @chooser_array.length == 4
        p "#{Player.name} choose a color and press 'enter'"
        choice = gets.chomp.downcase
        @chooser_array << choice
      end
      if @@player_game == true
        @player_array = @chooser_array
      else
        @selected_array = @chooser_array
      end
      p @player_array
    end

    def self.checker
      @result = []
      if @player_array == @selected_array
        p 'You Win'
        winner
      else
        i = 0
        p @player_array
        until i == @player_array.length
          if @selected_array.include?(@player_array[i])
            if @player_array[i] == @selected_array[i]
              @result << '●'
              @result
            elsif @player_array[i + 1] == @selected_array[i]
              @result << '◑'
              @result
            elsif @player_array[i - 1] == @selected_array[i]
              @result << '◐'
              @result
            else
              @result << '◒'
              @result
            end
          else
            @result << '○'

          end

          i += 1

        end
        p @result

      end
    end
  end

  class Computer < Player
    attr_accessor :name

    def initialize(name = 'PC')
      super
      @@player_game = false
    end

    def self.player_game
      Computer.choose
      random
      turn
    end

    def self.turn
      until @@win_con == true
        4.times do
          checker
          verifier
          p "PC tries #{@player_array}"
        end
        @@win_con = true
        p " #{Player.name} Won!"
      end
    end

    def self.checker
      super
    end

    def self.verifier
      j = 0
      @values = []

      until j == 4
        if @result[j] == '●'
          @values << [j, @player_array[j]]
          p @values
        elsif @result[j] == '◑'
          @values << [j + 1, @player_array[j + 1]]
        elsif @result[j] == '◐'
          @values << [j - 1, @player_array[j - 1]]
        elsif @result[j] == '○'
          @colors_array.delete(@player_array[j])
        end
        j += 1
      end
      random
      return if @values.nil?

      i = 0
      until i == @values.length

        @player_array.delete_at(@values[i][0])
        @player_array.insert(@values[i][0], @values[i][1])
        i += 1
      end
    end
  end
end

hoshua = Selector.new

p hoshua
