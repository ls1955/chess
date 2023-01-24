# frozen_string_literal: false

require_relative './chess_piece'

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

  def has_promote?
    COL_AMOUNT.times do |i|
      return true if occupy?(0, i) && chess_piece(0, i).promote?
    end

    false
  end

  def in_check?(curr_color:, enemy_color:)
    can_enemy_check?(enemy_color, king_coor(curr_color))
  end

  def movable?(old_row, old_col, new_row, new_col)
    chess_piece(old_row, old_col).path_valid?(self, old_row, old_col, new_row, new_col)
  end

  def move_piece(old_row, old_col, new_row, new_col)
    return unless occupy?(old_row, old_col) && chess_piece(old_row, old_col).path_valid?(self, old_row, old_col, new_row, new_col)

    chess_piece(old_row, old_col).had_move_once = true
    place(chess_piece(old_row, old_col), new_row, new_col)
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

  def promotable_piece_coor
    COL_AMOUNT.times do |i|
      return [0, i] if occupy?(0, i) && chess_piece(0, i).promote?
    end

    [-1, -1]
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

  def turn_around
    layout.map!(&:reverse)
    layout.reverse!
  end

  private

  def can_enemy_check?(enemy_color, king_coor)
    layout.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return true if occupy?(i, j) && piece.color == enemy_color && piece.path_valid?(self, i, j, king_coor[0], king_coor[1], as_enemy: true)
      end
    end

    false
  end

  def king_coor(curr_color)
    layout.each_with_index do |row, i|
      row.each_with_index do |piece, j|
        return [i, j] if occupy?(i, j) && piece.color == curr_color && piece.important?
      end
    end
  end
end
