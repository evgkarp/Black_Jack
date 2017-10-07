class Card
  attr_reader :face, :score

  class << self
    attr_accessor :deck
  end

  def self.create_deck
    values = ('2'..'10').to_a + %w[J Q K A]
    suits = %w[+ <3 <> ^]
    @deck = []
    values.each do |value|
      suits.each { |suit| @deck << (value + suit) }
    end
    @deck.shuffle!
  end

  create_deck

  def initialize
    @face = self.class.deck.delete_at(0)
    @score = score_count(@face)
  end

  def score_count(face)
    if %w[J Q K].include?(face[0])
      10
    elsif face[0] == 'A'
      11
    else
      face.to_i
    end
  end
end
