# frozen_string_literal: false

# parent class of all chess pieces
class BasicChessPiece
  attr_reader :color
  attr_accessor :symbol, :row, :col, :had_move_once, :dead

  def initialize(color, row, col)
    @symbol = ''
    @color = color
    @row = row
    @col = col
    @had_move_once = false
    @dead = false
  end

  def reachable_places; end

  def kill(chess)
    chess.dead = true
  end

  def promote!(_chess); end

  def to_s
    symbol
  end
end

# Pawn
class Pawn < BasicChessPiece
  def reachable_places
    [[row - 1, col], [row - 2, col]]
  end

  def symbol
    color == 'black' ? '♟︎' : '♙'
  end
end

# Rook
class Rook < BasicChessPiece
  def reachable_places
    (-8..8).each_with_object([]) do |offset, places|
      places << [row + offset, col]
      places << [row, col + offset]
    end
  end

  def symbol
    color == 'black' ? '♜' : '♖'
  end
end

# Knight
class Knight < BasicChessPiece
  def reachable_places
    [
      [row - 2, col - 1], [row - 2, col + 1],
      [row - 1, col - 2], [row - 1, col + 2],
      [row + 1, col - 2], [row + 1, col + 2],
      [row + 2, col - 1], [row + 2, col - 2]
    ]
  end

  def symbol
    color == 'black' ? '♞' : '♘'
  end
end

# Bishop
class Bishop < BasicChessPiece
  def reachable_places
    (-8..8).each_with_object([]) do |offset, places|
      places << [row + offset, col + offset]
    end
  end

  def symbol
    color == 'black' ? '♝' : '♗'
  end
end

# Queen
class Queen < BasicChessPiece
  def reachable_places
    (-8..8).each_with_object([]) do |offset, places|
      places << [row + offset, col + offset]
      places << [row + offset, col]
      places << [row, col + offset]
    end
  end

  def symbol
    color == 'black' ? '♛' : '♕'
  end
end

# King
class King < BasicChessPiece
  def reachable_places
    (-1..1).each_with_object([]) do |offset, places|
      places << [row + offset, col]
      places << [row, col + offset]
    end
  end

  def symbol
    color == 'black' ? '♚' : '♔'
  end
end
