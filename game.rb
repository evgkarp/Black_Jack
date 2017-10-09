require_relative 'player'
require_relative 'card'

class Game
  def initialize(name)
    validate!(name)
    @user = Player.new(name)
    @dealer = Player.new('Дилер')
    @players = [@user, @dealer]
  end

  def start
    Card.create_deck
    @game_bank = 0
    @players.each do |player|
      player.new_game
      bet(player)
    end
    dealing_cards
    show_game_table
    user_move
  end

  private

  def user_move
    puts "Ваш ход!
          Выберите действие:
          1 - Добавить карту
          2 - Пропустить ход
          3 - Открыть карты"

    action = gets.to_i

    case action
    when 1 then add_card(@user)
    when 2 then next_move(@user)
    when 3 then showdown
    else
      puts 'Введите число от 0 до 3'
      user_move
    end
  end

  def dealer_move
    puts 'Ход дилера!'
    if (@dealer.score < 17) && (@dealer.cards.size < 3)
      puts 'Дилер берет карту.'
      add_card(@dealer)
    else
      puts 'Дилер пропускает ход.'
      next_move(@dealer)
    end
  end

  def next_move(player)
    if (player == @user) && (@dealer.cards.size < 3)
      dealer_move
    elsif (player == @dealer) && (@user.cards.size < 3)
      user_move
    else
      showdown
    end
  end

  def add_card(player)
    player.add_card(Card.new)
    show_game_table
    next_move(player)
  end

  def dealing_cards
    puts 'Раздача карт...'
    2.times do
      @players.each { |player| player.add_card(Card.new) }
    end
  end

  def show_game_table
    puts "Ваши карты: #{@user.cards_faces}, ваши очки: #{@user.score}"
    puts "Карты дилера: #{hidden_cards(@dealer)}"
  end

  def hidden_cards(player)
    player.cards.map { '*' }
  end

  def bet(player)
    if player.bank >= 10
      player.bank -= 10
      @game_bank += 10
      puts "Ставка игрока #{player.name}: 10$, в банке игры: #{@game_bank}$"
    else
      puts "У игрока #{player.name} недостаточно средств для игры."
      exit
    end
  end

  def showdown
    puts 'Вскрываются карты!'
    puts "Ваши карты: #{@user.cards_faces}, ваши очки: #{@user.score}"
    puts "Карты дилера: #{@dealer.cards_faces}, очки дилера #{@dealer.score}"
    who_win
    banks_info
    again
  end

  def who_win
    if (@dealer.score == @user.score) || exceeding?(@user) && exceeding?(@dealer)
      @players.each { |player| player.bank += @game_bank / 2 }
      puts 'Ничья!'
    elsif ((@user.score > @dealer.score) && !exceeding?(@user)) || exceeding?(@dealer)
      puts 'Вы выиграли!'
      @user.bank += @game_bank
    elsif ((@dealer.score > @user.score) && !exceeding?(@dealer)) || exceeding?(@user)
      puts 'Выиграл Дилер!'
      @dealer.bank += @game_bank
    end
  end

  def exceeding?(player)
    player.score > 21
  end

  def banks_info
    puts "В вашем банке: #{@user.bank}$, в банке Дилера: #{@dealer.bank}$"
  end

  def again
    puts 'Играть еще?(Д/н)'
    action = gets.chomp
    action == 'Д' ? start : exit
  end

  def validate!(name)
    raise 'Имя не может быть пустым' if name.empty?
  end
end

puts 'Введите свое имя:'
name = gets.chomp

x = Game.new(name)
x.start
