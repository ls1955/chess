# frozen_string_literal: false

# chessboard
class ChessBoard
  attr_reader :row_amount, :col_amount

  def initialize
    @row_amount = 8
    @col_amount = 8
  end

  def color(row, col)
    if (row.even? && col.even?) || (row.odd? && col.odd?)
      'white'
    else
      'black'
    end
  end
end
