# frozen_string_literal: false

require_relative './chessboard'

# chess game
class Chess
  attr_reader :board, :player_round

  def initialize(board = ChessBoard)
    @board = board.new
    @player_round = 'white'
  end

  def invalid?(input)
    !valid?(input)
  end

  def input
    loop do
      puts "Current round: #{player_round}"
      p 'Please select a chess piece (Ex: a1): '

      input_str = gets.chomp

      if invalid?(input_str)
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

      puts 'Please select the destination (Ex: a1)'

      input_str = gets.chomp

      if invalid?(input_str)
        puts 'Invalid coordinate selected'
        next
      end

      to_row, to_col = input2row_col(input_str)

      unless board.movable?(from_row, from_col, to_row, to_col)
        puts 'Invalid move selected'
        next
      end

      return [from_row, from_col, to_row, to_col]
    end
  end

  def main
    board.place_chess_pieces_at_begin
    turn
    closing_statement
  end

  def switch_round
    @player_round = @player_round == 'white' ? 'black' : 'white'
  end

  def turn
  end

  def valid?(input)
    input.match?(/^[a-h][1-8]$/)
  end

  private

  def closing_statement
    puts
      if board.stalemate
        'There is no winner'
      else
        "Winner is #{player_round == 'white' ? 'white' : 'black'}"
      end
  end

  def input2row_col(input)
    col, row = input.split('')

    row = ChessBoard::ROW_AMOUNT - row.to_i
    col = col.tr('abcdefgh', '01234567').to_i

    [row, col]
  end
end
