# frozen_string_literal: true

class BasicChessPiece
  attr_reader :color
  attr_accessor :symbol, :had_move_once

  def initialize(color: '')
    @symbol = ''
    @color = color
    @had_move_once = false
  end

  def ally?(chess_piece)
    color == chess_piece.color
  end

  def enemy?(chess_piece)
    !ally?(chess_piece)
  end

  def enemy_block_path?(board, row, col, dest_row, dest_col)
    return [row, col] != [dest_row, dest_col] if enemy_in_path?(board, row, col)
  end

  def important?
    false
  end

  # Every classes except Pawn will ignore the last key argument.
  # As those classes's moveset is mirrored during player and enemy phases.
  # However, it is not the case for the pawn.
  def path_valid?(_board, _old_row, _old_col, _new_row, _new_col, as_enemy: false)
    raise NotImplementedError, '#path_valid? is not implemented'
  end

  def promote?
    false
  end

  def reachable?(old_row, old_col, new_row, new_col)
    reachable_places(old_row, old_col).include?([new_row, new_col])
  end

  def reachable_places(_old_row, _old_col)
    raise NotImplementedError, '#reachable_places is not implemented'
  end

  def to_s
    symbol
  end

  def unreachable?(row, col)
    !reachable?(row, col)
  end

  private

  def ally_in_path?(board, row, col)
    board.occupy?(row, col) && ally?(board.chess_piece(row, col))
  end

  def enemy_in_path?(board, row, col)
    board.occupy?(row, col) && enemy?(board.chess_piece(row, col))
  end
end

class Pawn < BasicChessPiece
  # TODO: mirrored attack range it it is enemy
  def path_valid?(board, old_row, old_col, new_row, new_col, as_enemy: false)
    if [old_row - 2, old_col] == [new_row, new_col]
      board.unoccupy?(old_row - 2, old_col) && board.unoccupy?(old_row - 1, old_col)
    elsif [old_row - 1, old_col] == [new_row, new_col]
      board.unoccupy?(old_row - 1, old_col)
    elsif !as_enemy && [old_row - 1, old_col - 1]
      return false if board.unoccupy?(old_row - 1, old_col - 1)

      enemy?(board.chess_piece(old_row - 1, old_col - 1))
    elsif !as_enemy && [old_row - 1, old_col + 1]
      return false if board.unoccupy?(old_row - 1, old_col + 1)

      enemy?(board.chess_piece(old_row - 1, old_col + 1))
    elsif as_enemy && [old_row + 1, old_col + 1]
      return false if board.unoccupy?(old_row + 1, old_col + 1)

      enemy?(board.chess_piece(old_row + 1, old_col + 1))
    elsif as_enemy && [old_row + 1, old_col - 1]
      return false if board.unoccupy?(old_row + 1, old_col - 1)

      enemy?(board.chess_piece(old_row + 1, old_col - 1))
    else
      false
    end
  end

  def promote?
    true
  end

  def reachable?(old_row, old_col, new_row, new_col)
    case [new_row, new_col]
    when [old_row - 2, old_col]
      !had_move_once
    when [old_row - 1, old_col]
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
  def path_valid?(board, old_row, old_col, new_row, new_col, as_enemy: false)
    return false unless reachable?(old_row, old_col, new_row, new_col)

    if old_row > new_row
      distance = old_row - new_row

      (1..distance).each { |offset| return false if ally_in_path?(board, old_row - offset, old_col) || enemy_block_path?(board, old_row - offset, old_col, new_row, new_col) }
    elsif old_row < new_row
      distance = new_row - old_row

      (1..distance).each { |offset| return false if ally_in_path?(board, old_row + offset, old_col) || enemy_block_path?(board, old_row + offset, old_col, new_row, new_col) }
    elsif old_col > new_col
      distance = old_col - new_col

      (1..distance).each { |offset| return false if ally_in_path?(board, old_row, old_col - offset) || enemy_block_path?(board, old_row, old_col - offset, new_row, new_col) }
    else
      distance = new_col - old_col

      (1..distance).each { |offset| return false if ally_in_path?(board, old_row, old_col + offset) || enemy_block_path?(board, old_row, old_col + offset, new_row, new_col) }
    end

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
  def path_valid?(board, old_row, old_col, new_row, new_col, as_enemy: false)
    reachable?(old_row, old_col, new_row, new_col) && !ally_in_path?(board, new_row, new_col)
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
  def path_valid?(board, old_row, old_col, new_row, new_col, as_enemy: false)
    return false unless reachable?(old_row, old_col, new_row, new_col)

    distance = (old_row - new_row).abs
    if bottom_right_corner?(old_row, old_col, new_row, new_col)
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row - offset, old_col - offset) || enemy_block_path?(board, old_row - offset, old_col - offset, new_row, new_col) }
    elsif bottom_left_corner?(old_row, old_col, new_row, new_col)
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row - offset, old_col + offset) || enemy_block_path?(board, old_row - offset, old_col + offset, new_row, new_col) }
    elsif upper_right_corner?(old_row, old_col, new_row, new_col)
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row + offset, old_col - offset) || enemy_block_path?(board, old_row + offset, old_col - offset, new_row, new_col) }
    else
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row + offset, old_col + offset) || enemy_block_path?(board, old_row + offset, old_col + offset, new_row, new_col) }
    end

    true
  end

  def reachable_places(old_row, old_col)
    8.times.each_with_object([]) do |offset, places|
      places << [old_row + offset, old_col + offset]
      places << [old_row + offset, old_col - offset]
      places << [old_row - offset, old_col + offset]
      places << [old_row - offset, old_col - offset]
    end
  end

  def symbol
    color == 'black' ? '♝' : '♗'
  end

  private
  def bottom_left_corner?(old_row, old_col, new_row, new_col)
    old_row > new_row && old_col < new_col
  end

  def bottom_right_corner?(old_row, old_col, new_row, new_col)
    old_row > new_row && old_col > new_col
  end

  def upper_right_corner?(old_row, old_col, new_row, new_col)
    old_row < new_row && old_col > new_col
  end

  def upper_left_corner?(old_row, old_col, new_row, new_col)
    old_row < new_row && old_col < new_col
  end
end

class Queen < BasicChessPiece
  def path_valid?(board, old_row, old_col, new_row, new_col, as_enemy: false)
    return false unless reachable?(old_row, old_col, new_row, new_col)

    distance = (old_row - new_row).abs
    if bottom_right_corner?(old_row, old_col, new_row, new_col)
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row - offset, old_col - offset) || enemy_block_path?(board, old_row - offset, old_col - offset, new_row, new_col) }
    elsif bottom_left_corner?(old_row, old_col, new_row, new_col)
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row - offset, old_col + offset) || enemy_block_path?(board, old_row - offset, old_col + offset, new_row, new_col) }
    elsif upper_right_corner?(old_row, old_col, new_row, new_col)
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row + offset, old_col - offset) || enemy_block_path?(board, old_row + offset, old_col - offset, new_row, new_col) }
    elsif upper_left_corner?(old_row, old_col, new_row, new_col)
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row + offset, old_col + offset) || enemy_block_path?(board, old_row + offset, old_col + offset, new_row, new_col) }
    elsif old_row > new_row
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row - offset, old_col) || enemy_block_path?(board, old_row - offset, old_col, new_row, new_col) }
    elsif old_row < new_row
      (1..distance).each { |offset| return false if ally_in_path?(board, old_row + offset, old_col) || enemy_block_path?(board, old_row + offset, old_col, new_row, new_col) }
    elsif old_col > new_col
      distance = old_col - new_col

      (1..distance).each { |offset| return false if ally_in_path?(board, old_row, old_col - offset) || enemy_block_path?(board, old_row, old_col - offset, new_row, new_col) }
    else
      distance = new_col - old_col

      (1..distance).each { |offset| return false if ally_in_path?(board, old_row, old_col + offset) || enemy_block_path?(board, old_row, old_col + offset, new_row, new_col) }
    end

    true
  end

  def reachable_places(old_row, old_col)
    (1..7).each_with_object([]) do |offset, places|
      places << [old_row + offset, old_col + offset]
      places << [old_row + offset, old_col - offset]
      places << [old_row - offset, old_col + offset]
      places << [old_row - offset, old_col - offset]
      places << [old_row + offset, old_col]
      places << [old_row - offset, old_col]
      places << [old_row, old_col + offset]
      places << [old_row, old_col - offset]
    end
  end

  def symbol
    color == 'black' ? '♛' : '♕'
  end

  private
  def bottom_left_corner?(old_row, old_col, new_row, new_col)
    old_row > new_row && old_col < new_col
  end

  def bottom_right_corner?(old_row, old_col, new_row, new_col)
    old_row > new_row && old_col > new_col
  end

  def upper_right_corner?(old_row, old_col, new_row, new_col)
    old_row < new_row && old_col > new_col
  end

  def upper_left_corner?(old_row, old_col, new_row, new_col)
    old_row < new_row && old_col < new_col
  end
end

class King < BasicChessPiece
  def important?
    true
  end

  def path_valid?(board, old_row, old_col, new_row, new_col, as_enemy: false)
    return false unless reachable?(old_row, old_col, new_row, new_col)

    if old_row > new_row
      return false if ally_in_path?(board, old_row - 1, old_col) || enemy_block_path?(board, old_row - 1, old_col, new_row, new_col)
    elsif old_row < new_row
      return false if ally_in_path?(board, old_row + 1, old_col) || enemy_block_path?(board, old_row + 1, old_col, new_row, new_col)
    elsif old_col > new_col
      return false if ally_in_path?(board, old_row, old_col - 1) || enemy_block_path?(board, old_row, old_col - 1, new_row, new_col)
    else
      return false if ally_in_path?(board, old_row, old_col + 1) || enemy_block_path?(board, old_row, old_col + 1, new_row, new_col)
    end

    true
  end

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


