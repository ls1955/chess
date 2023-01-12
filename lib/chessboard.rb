# frozen_string_literal: false

require_relative './chess_piece'

# chessboard
class ChessBoard
  ROW_AMOUNT = 8
  COL_AMOUNT = 8

  attr_reader :layout

  def initialize
    @layout = Array.new(ROW_AMOUNT) { Array.new(COL_AMOUNT, ' ') }
  end

  def chess_piece(row, col)
    layout[row][col]
  end

  def movable?(old_row, old_col, new_row, new_col)
    # chess_piece = layout[old_row, old_col]

    # chess_piece.reachable?(old_row, old_col, new_row, new_col)
  end

  def move_piece(old_row, old_col, new_row, new_col)
    return unless chess_piece(old_row, old_col).path_valid?(self, old_row, old_col, new_row, new_col)

    place(chess_piece(old_row, old_col), new_row, new_col)
    chess_piece(old_row, old_col).had_move_once = true
    layout[old_row][old_col] = ' '
  end

  def occupy?(row, col)
    layout[row][col] != ' '
  end

  def place(chess_piece, row, col)
    layout[row][col] = chess_piece
  end

  def place_chess_pieces_at_begin
    chess_piece_types = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    chess_piece_types.each_with_index do |type, col_offset|
      layout[0][0 + col_offset] = type.new(color: 'black')
      layout[ROW_AMOUNT - 1][0 + col_offset] = type.new(color: 'white')
    end

    COL_AMOUNT.times do |col_offset|
      layout[1][0 + col_offset] = Pawn.new(color: 'black')
      layout[ROW_AMOUNT - 2][0 + col_offset] = Pawn.new(color: 'white')
    end
  end

  def tile_color(row, col)
    if row.even? == col.even?
      'white'
    else
      'black'
    end
  end

  def to_s
    a_to_h = ('a'..'h').to_a.join(' ')
    s = "   #{a_to_h}\n"

    layout.each_with_index do |row, r|
      row_num = (8 - r).to_s
      row = row.map(&:to_s).join('|')

      s << "#{row_num} |#{row}| #{row_num}\n"
    end
    s << "  -----------------\n   #{a_to_h}\n"
  end

  def unoccupy?(row, col)
    !occupy?(row, col)
  end
end
