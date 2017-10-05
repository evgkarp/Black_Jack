class Dealer < Player
  def hidden_cards
    @cards.map { '*' }
  end
end
