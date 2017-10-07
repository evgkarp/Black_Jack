class Player
  attr_reader :name
  attr_accessor :cards, :bank

  def initialize(name)
    @name = name
    @bank = 100
    @cards = []
  end

  def add_card(card)
    @cards << card
  end

  def cards_faces
    @cards.map(&:face)
  end

  def score
    score = 0
    @cards.each { |card| score += card.score }
    @cards.each do |card|
      score -= 10 if (card.face[0] == 'A') && (score > 21)
    end
    score
  end

  def new_game
    @cards = []
  end
end
