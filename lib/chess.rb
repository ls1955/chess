# frozen_string_literal: false

require_relative './chessboard'

# chess game
class Chess
  def initialize(board = ChessBoard)
    @board = board.new
    @player_round = 'white'
  end

  def input2row_col(input)
    col, row = input.split('')

    row = ChessBoard::ROW_AMOUNT - row.to_i
    col = col.tr('abcdefgh', '01234567').to_i

    [row, col]
  end

  def invalid?(input)
    !valid?(input)
  end

  def input
    loop do
      puts "Current round: #{player_round}"
      p 'Please choose a coordinate (Ex: a1): '

      input_str = gets.chomp

      if invalid?(input_str)
        puts 'Invalid coordinate selected.'
        next
      end

      row, col = input2row_col(input_str)
      chess_piece = board.chess_piece(row, col)

      if chess_piece.color != player_round
        puts 'This is not your chess.'
      elsif board.unoccupy?(row, col)
        puts 'There is no chess there.'
      elsif !board.movable?(row, col)
        puts 'The chess could not move there.'
      else
        return input_str
      end
    end
  end

  def valid?(input)
    input.match?(/^[a-h][1-8]$/)
  end
end
