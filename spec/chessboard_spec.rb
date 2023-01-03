# frozen_string_literal: false

require_relative './../lib/chessboard'

describe ChessBoard do
  subject(:chessboard) { described_class.new }

  context 'upon initialization' do
    it 'has 8 rows' do
      expect(chessboard.row_amount).to eq(8)
    end

    it 'has 8 columns' do
      expect(chessboard.col_amount).to eq(8)
    end

    it 'first row, first column is black' do
      color = chessboard.color(0, 0)

      expect(color).to eq('white')
    end

    it 'first row, second column is white' do
      color = chessboard.color(0, 1)

      expect(color).to eq('black')
    end

    it 'last row, last column is white' do
      color = chessboard.color(7, 7)

      expect(color).to eq('white')
    end

    it 'show an empty board' do
      board_view = <<~BOARD
        | | | | | | | | |
        | | | | | | | | |
        | | | | | | | | |
        | | | | | | | | |
        | | | | | | | | |
        | | | | | | | | |
        | | | | | | | | |
        | | | | | | | | |
      BOARD

      expect(board.to_s).to eq(board_view)
    end
  end
end