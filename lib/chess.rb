# frozen_string_literal: false

require_relative './chess_piece'
require_relative './chess_board'
require_relative './chess_board_prompt'
require 'yaml'

class Chess
  attr_reader :prompt
  attr_accessor :board, :has_resign, :player_round, :turn_counter

  def initialize(board = ChessBoard, prompt = ChessBoardPrompt)
    @board = board.new
    @has_resign = false
    @player_round = 'white'
    @prompt = prompt.new
    @turn_counter = 1
  end

  def main
    puts prompt.player_menu
    input = gets.chomp

    board.place_chess_pieces_at_begin

    load_file if input == '2'

    game_loop
    puts prompt.game_over(has_resign, current_player, next_player)
  end

  def input2row_col(input)
    col, row = input.split('')

    row = ChessBoard::ROW_AMOUNT - row.to_i
    col = col.tr('abcdefgh', '01234567').to_i

    [row, col]
  end

  def valid?(input)
    input.match?(/^[a-h][1-8]$/)
  end

  private

  def current_player
    player_round == 'white' ? 'white' : 'black'
  end

  def game_loop
    loop do
      from_row, from_col, to_row, to_col = select_piece
      board.move_piece(from_row, from_col, to_row, to_col)

      promote_piece if board.has_promote?

      break unless board.both_king_alive?

      switch_round
    end
  end

  def invalid?(input)
    !valid?(input)
  end

  def load_file
    data = YAML.load(File.read('./save/saved.yml'), permitted_classes: [Rook, Knight, Bishop, Queen, King, Pawn])
    @player_round = data[0]
    @turn_counter = data[1]
    @has_resign = data[2]
    board.layout = data[3]
  end

  def next_player
    current_player == 'white' ? 'black' : 'white'
  end

  def closing_statement
    puts prompt.winner(has_resign ? next_player : current_plaer)
  end

  def promote_piece
    puts prompt.promotion
    klass = gets.chomp.capitalize
    pawn_row, pawn_col = board.promotable_piece_coor

    case klass
    when 'Pawn'
      puts 'Really?'
    when 'Rook'
      board.place(Rook.new(color: current_player), pawn_row, pawn_col)
    when 'Knight'
      board.place(Knight.new(color: current_player), pawn_row, pawn_col)
    when 'Bishop'
      board.place(Bishop.new(color: current_player), pawn_row, pawn_col)
    when 'Queen'
      puts 'Ah, the classic choice.'
      board.place(Queen.new(color: current_player), pawn_row, pawn_col)
    end
  end

  def save
    data = [player_round, turn_counter, has_resign, board.layout]
    File.open('./save/saved.yml', 'w') { |file| file.write(data.to_yaml) }
  end

  def select_piece
    loop do
      puts prompt.check if board.in_check?(curr_color: current_player, enemy_color: next_player)
      puts prompt.current_round_info(board, player_round, turn_counter)
      input_str = gets.chomp

      if input_str == 'resign'
        has_resign = true
        break
      elsif input_str == 'save'
        save
        puts 'Game has been saved.'
        exit
      elsif invalid?(input_str)
        puts prompt.invalid_input
        next
      end

      from_row, from_col = input2row_col(input_str)
      chess_piece = board.chess_piece(from_row, from_col)

      if board.unoccupy?(from_row, from_col)
        puts prompt.chess_not_find
        next
      elsif chess_piece.color != player_round
        puts prompt.wrong_chess_chosen
        next
      end

      return select_destination(from_row, from_col)
    end
  end

  def select_destination(from_row, from_col)
    loop do
      puts prompt.select_destination(board)
      input_str = gets.chomp

      return select_piece if input_str == 'redo'

      if invalid?(input_str)
        puts prompt.invalid_input
        next
      end

      to_row, to_col = input2row_col(input_str)

      if [from_row, from_col] == [to_row, to_col]
        puts prompt.identical_place_selected
        next
      elsif !board.movable?(from_row, from_col, to_row, to_col)
        puts prompt.invalid_move
        next
      end

      # NOTE: Although is is possible to make sure player
      # always avoiding check when being check
      # due to the complexity of declaring CHECKMATE
      # below functionality has been commented out

      # prev_board = Marshal.dump(board)
      # board.move_piece(from_row, from_col, to_row, to_col)

      # if board.in_check?(curr_color: current_player, enemy_color: next_player)
      #   puts 'The king is being check, please reselect your move.'
      #   @board = Marshal.load(prev_board)
      #   return select_piece
      # end

      # @board = Marshal.load(prev_board)
      return [from_row, from_col, to_row, to_col]
    end
  end

  def switch_round
    @player_round = @player_round == 'white' ? 'black' : 'white'
    @turn_counter += 1
    board.turn_around
  end
end
