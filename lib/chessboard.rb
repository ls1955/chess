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

  def tile_color(row, col)
    if (row.even? && col.even?) || (row.odd? && col.odd?)
      'white'
    else
      'black'
    end
  end

  def place(chess, row, col)
    layout[row][col] = chess
  end

  def move(chess, prev_row, prev_col, row, col)
    place(chess, row, col)
    layout[prev_row][prev_col] = ' '
  end

  def place_chess_pieces_at_begin
    chess_piece_types = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

    chess_piece_types.each_with_index do |type, col_offset|
      layout[0][0 + col_offset] = type.new('black', 0, 0 + col_offset)
      layout[ROW_AMOUNT - 1][0 + col_offset] = type.new('white', ROW_AMOUNT - 1, 0 + col_offset)
    end

    COL_AMOUNT.times do |col_offset|
      layout[1][0 + col_offset] = Pawn.new('black', 1, 0 + col_offset)
      layout[ROW_AMOUNT - 2][0 + col_offset] = Pawn.new('white', ROW_AMOUNT - 2, 0 + col_offset)
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
end
