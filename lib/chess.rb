# frozen_string_literal: false

require_relative './chess_board'

# chess game
class Chess
  attr_reader :player_round, :turn_counter
  attr_accessor :is_game_over, :has_resign, :board

  def initialize(board = ChessBoard)
    @board = board.new
    @has_resign = false
    @is_game_over = false
    @player_round = 'white'
    @turn_counter = 1
  end

  def main
    # provide load game utility at beginning?
    board.place_chess_pieces_at_begin
    turn
    closing_statement
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

  def closing_statement
    if has_resign
      puts "Winner is #{next_player}"
    else
      puts "Winner is #{current_player}"
    end
  end

  def invalid?(input)
    !valid?(input)
  end

  def next_player
    current_player == 'white' ? 'black' : 'white'
  end

  def select_piece
    loop do
      puts <<~PROMPT
        #{board}
        ----------------------------------------
               Current round: #{player_round}
                    Turn: #{turn_counter}
        Please select a chess piece (Ex: a1)
        Enter 'resign' to forfeit the game
        Enter 'save' to save & quit the game
        ----------------------------------------
      PROMPT
      input_str = gets.chomp

      if input_str == 'resign'
        has_resign = true
        break
      elsif input_str == 'save'
        # save the game
        puts 'Game has been saved.'
        # exit
      elsif invalid?(input_str)
        puts 'Invalid coordinate selected.'
        next
      end

      from_row, from_col = input2row_col(input_str)
      chess_piece = board.chess_piece(from_row, from_col)

      if board.unoccupy?(from_row, from_col)
        puts 'There is no chess there.'
        next
      elsif chess_piece.color != player_round
        puts 'This is not your chess.'
        next
      end

      return select_destination(from_row, from_col)
    end
  end

  def select_destination(from_row, from_col)
    loop do
      puts <<~PROMPT

        #{board}
        ----------------------------------------
        Please select the destination (Ex: a1)
        Enter 'redo' to reselect chess piece
        ----------------------------------------

      PROMPT
      input_str = gets.chomp

      return select_piece if input_str == 'redo'

      if invalid?(input_str)
        puts 'Invalid coordinate selected'
        next
      end

      to_row, to_col = input2row_col(input_str)

      if [from_row, from_col] == [to_row, to_col]
        puts 'Identical place selected'
        next
      elsif !board.movable?(from_row, from_col, to_row, to_col)
        puts <<~PROMPT


          ----------------------------------------
                    Invalid move selected
          ----------------------------------------


        PROMPT
        next
      end

      prev_board = Marshal.dump(board)
      board.move_piece(from_row, from_col, to_row, to_col)

      if board.in_check?(curr_color: current_player, enemy_color: next_player)
        puts 'The king is being check, please reselect your move.'
        @board = Marshal.load(prev_board)
        return select_piece
      end

      @board = Marshal.load(prev_board)
      return [from_row, from_col, to_row, to_col]
    end
  end

  def switch_round
    @player_round = @player_round == 'white' ? 'black' : 'white'
    @turn_counter += 1
    board.turn_around
  end

  def turn
    loop do
      from_row, from_col, to_row, to_col = select_piece
      board.move_piece(from_row, from_col, to_row, to_col)
      switch_round
    end
  end
end
