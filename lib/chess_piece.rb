# frozen_string_literal: true

class BasicChessPiece
  attr_reader :color
  attr_accessor :symbol, :had_move_once, :dead

  def initialize(color: '')
    @symbol = ''
    @color = color
    @had_move_once = false
    @dead = false
  end

  def ally?(chess_piece)
    color == chess_piece.color
  end

  def enemy?(chess_piece)
    !ally?(chess_piece)
  end

  def kill(chess_piece)
    chess_piece.dead = true
  end

  def path_valid?(_board, _old_row, _old_col, _new_row, _new_col)
    nil
  end

  def promote!(_chess_piece)
    nil
  end

  def reachable?(old_row, old_col, new_row, new_col)
    reachable_places(old_row, old_col).include?([new_row, new_col])
  end

  def reachable_places(_old_row, _old_col)
    []
  end

  def to_s
    symbol
  end

  def unreachable?(row, col)
    !reachable?(row, col)
  end
end

class Pawn < BasicChessPiece
  def path_valid?(board, old_row, old_col, new_row, new_col)
    if [old_row - 2, old_col] == [new_row, new_col]
      return false if board.occupy?(old_row - 2, old_col) || board.occupy?(old_row - 1, old_col)

      true
    elsif [old_row - 1, old_col] == [new_row, new_col]
      return false if board.occupy?(old_row - 1, old_col)

      true
    elsif [old_row - 1, old_col - 1] == [new_row, new_col]
      return false unless board.occupy?(old_row - 1, old_col - 1)

      if ally?(board.chess_piece(old_row - 1, old_col - 1))
        false
      else
        kill(board.chess_piece(old_row - 1, old_col - 1))
        true
      end
    elsif [old_row - 1, old_col + 1] == [new_row, new_col]
      return false unless board.occupy?(old_row - 1, old_col + 1)

      if ally?(board.chess_piece(old_row - 1, old_col + 1))
        false
      else
        kill(board.chess_piece(old_row - 1, old_col + 1))
        true
      end
    else
      false
    end
  end

  def reachable?(old_row, old_col, new_row, new_col)
    if [old_row - 2, old_col] == [new_row, new_col]
      had_move_once ? false : true
    elsif [old_row - 1, old_col] == [new_row, new_col]
      true
    else
      false
    end
  end

  def symbol
    color == 'black' ? '♟︎' : '♙'
  end
end

class Rook < BasicChessPiece
  def path_valid?(board, old_row, old_col, new_row, new_col)
    return unless reachable?(old_row, old_col, new_row, new_col)

    if old_row > new_row
      distance = old_row - new_row

      (1..distance).each { |offset| return false if board.occupy?(old_row - offset, old_col) && ally?(board.chess_piece(old_row - offset, old_col)) }
    elsif old_row < new_row
      distance = new_row - old_row

      (1..distance).each { |offset| return false if board.occupy?(old_row + offset, old_col) && ally?(board.chess_piece(old_row + offset, old_col)) }
    elsif old_col > new_col
      distance = old_col - new_col

      (1..distance).each { |offset| return false if board.occupy?(old_row, old_col - offet) && ally?(board.chess_piece(old_row, old_col - offset)) }
    else
      distance = new_col - old_col

      (1..distance).each { |offset| return false if board.occupy?(old_row, old_col + offset) && ally?(board.chess_piece(old_row, old_col + offset)) }
    end

    kill(board.chess_piece(new_row, new_col)) if board.occupy?(new_row, new_col)

    true
  end

  def reachable_places(old_row, old_col)
    (-7..7).each_with_object([]) do |offset, places|
      places << [old_row + offset, old_col]
      places << [old_row, old_col + offset]
    end
  end

  def symbol
    color == 'black' ? '♜' : '♖'
  end
end

class Knight < BasicChessPiece
  def path_valid?(board, old_row, old_col, new_row, new_col)
    return false unless reachable?(old_row, old_col, new_row, new_col)

    if enemy?(board.chess_piece(new_row, new_col))
      kill(board.chess_piece(new_row, new_col))
      true
    else
      false
    end
  end

  def reachable_places(old_row, old_col)
    [
      [old_row - 2, old_col - 1], [old_row - 2, old_col + 1],
      [old_row - 1, old_col - 2], [old_row - 1, old_col + 2],
      [old_row + 1, old_col - 2], [old_row + 1, old_col + 2],
      [old_row + 2, old_col - 1], [old_row + 2, old_col - 2]
    ]
  end

  def symbol
    color == 'black' ? '♞' : '♘'
  end
end

class Bishop < BasicChessPiece
  def reachable_places(old_row, old_col)
    (-7..7).each_with_object([]) do |offset, places|
      places << [old_row + offset, old_col + offset]
    end
  end

  def symbol
    color == 'black' ? '♝' : '♗'
  end
end

class Queen < BasicChessPiece
  def reachable_places(old_row, old_col)
    (-7..7).each_with_object([]) do |offset, places|
      places << [old_row + offset, old_col + offset]
      places << [old_row + offset, old_col]
      places << [old_row, old_col + offset]
    end
  end

  def symbol
    color == 'black' ? '♛' : '♕'
  end
end

class King < BasicChessPiece
  def reachable_places(old_row, old_col)
    (-1..1).each_with_object([]) do |offset, places|
      places << [old_row + offset, old_col]
      places << [old_row, old_col + offset]
      places << [old_row + offset, old_col + offset]
    end
  end

  def symbol
    color == 'black' ? '♚' : '♔'
  end
end
