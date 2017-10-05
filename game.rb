require_relative 'player'
require_relative 'dealer'

class Game
  def initialize(name)
    validate!(name)
    @user = Player.new(name)
    @dealer = Dealer.new('Дилер')
    @players = [@user, @dealer]
  end

  def start
    @game_bank = 0
    @players.each(&:new_game)
    @players.each { |player| bet(player) }
    @deck = shuffle_deck
    dealing_cards
    show_game_table
    user_move
  end

  private

  def user_move
    sleep(2)
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
      input_error
    end
  rescue => e
    puts e.message
    retry
  end

  def input_error
    raise 'Введите число от 0 до 3'
  end

  def dealer_move
    sleep(2)
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
    player.add_card(take_card_from_deck)
    show_game_table
    next_move(player)
  end

  def take_card_from_deck
    @deck.delete_at(0)
  end

  def shuffle_deck
    ['2+', '3+', '4+', '5+', '6+', '7+', '8+', '9+', '10+', 'J+', 'Q+', 'K+', 'A+',
     '2<3', '3<3', '4<3', '5<3', '6<3', '7<3', '8<3', '9<3', '10<3', 'J<3', 'Q<3', 'K<3', 'A<3',
     '2<>', '3<>', '4<>', '5<>', '6<>', '7<>', '8<>', '9<>', '10<>', 'J<>', 'Q<>', 'K<>', 'A<>',
     '2^', '3^', '4^', '5^', '6^', '7^', '8^', '9^', '10^', 'J^', 'Q^', 'K^', 'A^'].shuffle
  end

  def dealing_cards
    sleep(2)
    puts 'Раздача карт...'
    2.times do
      @players.each { |player| player.add_card(take_card_from_deck) }
    end
  end

  def show_game_table
    sleep(2)
    puts "Ваши карты: #{@user.cards}, ваши очки: #{@user.score}"
    puts "Карты дилера: #{@dealer.hidden_cards}"
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
    sleep(2)
    puts 'Вскрываются карты!'
    puts "Ваши карты: #{@user.cards}, ваши очки: #{@user.score}"
    puts "Карты дилера: #{@dealer.cards}, очки дилера #{@dealer.score}"
    who_win
    banks_info
    again
  end

  def who_win
    sleep(2)
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
    player.score > 21 ? true : false
  end

  def banks_info
    sleep(2)
    puts "В вашем банке: #{@user.bank}$, в банке Дилера: #{@dealer.bank}$"
  end

  def again
    sleep(2)
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
