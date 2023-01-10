# frozen_string_literal: false

require_relative './../lib/chessboard'

describe ChessBoard do
  subject(:chessboard) { described_class.new }
  let(:chess_piece) { '♟' }

  context 'after initialization' do
    it 'has an 8 by 8 matrix' do
      expected = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
      ]

      expect(chessboard.layout).to eq(expected)
    end

    it 'show an empty board' do
      expected = <<~BOARD
           a b c d e f g h
        8 | | | | | | | | | 8
        7 | | | | | | | | | 7
        6 | | | | | | | | | 6
        5 | | | | | | | | | 5
        4 | | | | | | | | | 4
        3 | | | | | | | | | 3
        2 | | | | | | | | | 2
        1 | | | | | | | | | 1
          -----------------
           a b c d e f g h
      BOARD

      expect(chessboard.to_s).to eq(expected)
    end
  end

  describe '#chess_piece' do
    it 'return the chess at given row and column index' do
      chessboard.place(chess_piece, 0, 0)

      expected = chessboard.chess_piece(0, 0)

      expect(expected).to be chess_piece
    end
  end

  describe '#move' do
    context 'when given a chess piece previous and new row and column index' do
      it 'moves the chess to desirable slot' do
        chessboard.move(chess_piece, 7, 0, 6, 0)

        expected = <<~BOARD
             a b c d e f g h
          8 | | | | | | | | | 8
          7 | | | | | | | | | 7
          6 | | | | | | | | | 6
          5 | | | | | | | | | 5
          4 | | | | | | | | | 4
          3 | | | | | | | | | 3
          2 |♟| | | | | | | | 2
          1 | | | | | | | | | 1
            -----------------
             a b c d e f g h
        BOARD

        expect(chessboard.to_s).to eq(expected)
      end
    end
  end

  describe '#occupy?' do
    context 'when given a row and column index' do
      it 'return true if slot is occupy' do
        chessboard.place(chess_piece, 3, 5)

        expect(chessboard.occupy?(3, 5)).to be true
      end

      it 'return false if slot is not occupy' do
        chessboard.place(chess_piece, 3, 7)

        expect(chessboard.occupy?(3, 5)).to be false
      end
    end
  end

  describe '#place' do
    context 'when given a chess piece row and column index' do
      it 'place the chess at desirable slot' do
        chessboard.place(chess_piece, 7, 0)

        expected = <<~BOARD
             a b c d e f g h
          8 | | | | | | | | | 8
          7 | | | | | | | | | 7
          6 | | | | | | | | | 6
          5 | | | | | | | | | 5
          4 | | | | | | | | | 4
          3 | | | | | | | | | 3
          2 | | | | | | | | | 2
          1 |♟| | | | | | | | 1
            -----------------
             a b c d e f g h
        BOARD

        expect(chessboard.to_s).to eq(expected)
      end
    end
  end

  describe '#place_chess_pieces_at_begin' do
    it 'place the chess pieces at the beginning' do
      chessboard.place_chess_pieces_at_begin

      expected = <<~BOARD
           a b c d e f g h
        8 |♜|♞|♝|♛|♚|♝|♞|♜| 8
        7 |♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎| 7
        6 | | | | | | | | | 6
        5 | | | | | | | | | 5
        4 | | | | | | | | | 4
        3 | | | | | | | | | 3
        2 |♙|♙|♙|♙|♙|♙|♙|♙| 2
        1 |♖|♘|♗|♕|♔|♗|♘|♖| 1
          -----------------
           a b c d e f g h
      BOARD

      expect(chessboard.to_s).to eq(expected)
    end
  end

  describe '#tile_color' do
    context "when given a row and column index" do
      it 'first row, first column is white' do
        color = chessboard.tile_color(0, 0)

        expect(color).to eq('white')
      end

      it 'first row, second column is black' do
        color = chessboard.tile_color(0, 1)

        expect(color).to eq('black')
      end

      it 'last row, last column is white' do
        color = chessboard.tile_color(7, 7)

        expect(color).to eq('white')
      end
    end
  end

  describe '#unoccupy?' do
    context 'when given a row and column index' do
      it 'return true if there is no chess piece' do
        row = 0
        col = 0

        expected = chessboard.unoccupy?(row, col)

        expect(expected).to be true
      end

      it 'return false if there is chess piece' do
        row = 0
        col = 0
        chessboard.place(chess_piece, 0, 0)

        expected = chessboard.unoccupy?(row, col)

        expect(expected).to be false
      end
    end
  end
end
