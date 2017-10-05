class Player
  attr_reader :name, :score
  attr_accessor :cards, :bank

  def initialize(name)
    @name = name
    @bank = 100
    @cards = []
    @score = 0
  end

  def add_card(card)
    @cards << card
    @score += score_count(card)
  end

  def score_count(card)
    if %w[J Q K].include?(card[0])
      10
    elsif (card[0] == 'A') && (@score < 11)
      11
    elsif (card[0] == 'A') && (@score > 10)
      1
    else
      card.to_i
    end
  end

  def new_game
    @cards = []
    @score = 0
  end
end
