# frozen_string_literal: false

require_relative './../lib/chessboard'

describe ChessBoard do
  subject(:chessboard) { described_class.new }

  context 'after initialization' do
    it 'has an 8 by 8 matrix' do
      matrix = [
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
      ]

      expect(chessboard.layout).to eq(matrix)
    end

    it 'show an empty board' do
      view = <<~BOARD
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

      expect(chessboard.to_s).to eq(view)
    end
  end

  describe '#tile_color' do
    context "when being ask about particular slot's color" do
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

  describe '#place' do
    let(:chess) { '♟' }
    context 'when given a chess, row and column index' do
      it 'place the chess at desirable slot' do
        chessboard.place(chess, 7, 0)
        view = <<~BOARD
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

        expect(chessboard.to_s).to eq(view)
      end
    end
  end

  describe '#move' do
    let(:chess) { '♟' }
    context 'when given a chess, previous and new row and column index' do
      it 'moves the chess to desirable slot' do
        chessboard.move(chess, 7, 0, 6, 0)
        view = <<~BOARD
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

        expect(chessboard.to_s).to eq(view)
      end
    end
  end

  describe '#place_chess_pieces_at_begin' do
    it 'place the chess pieces at the beginning' do
      view = <<~BOARD
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
      chessboard.place_chess_pieces_at_begin

      expect(chessboard.to_s).to eq(view)
    end
  end
end
