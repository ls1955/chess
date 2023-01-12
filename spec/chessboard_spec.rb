# frozen_string_literal: true

require_relative './../lib/chessboard'
require_relative './../lib/chess_piece'

describe ChessBoard do
  subject(:chessboard) { described_class.new }
  let(:chess_piece) { Pawn.new(color: 'black') }

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

  describe '#move_piece' do
    context 'when given a chess piece previous and new row and column index' do
      it 'moves the chess to desirable slot' do
        chessboard.place(chess_piece, 7, 0)
        chessboard.move_piece(7, 0, 6, 0)

        expected = <<~BOARD
             a b c d e f g h
          8 | | | | | | | | | 8
          7 | | | | | | | | | 7
          6 | | | | | | | | | 6
          5 | | | | | | | | | 5
          4 | | | | | | | | | 4
          3 | | | | | | | | | 3
          2 |♟︎| | | | | | | | 2
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
          1 |♟︎| | | | | | | | 1
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

# Integration test between boards and pawns
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_pawn1) { Pawn.new(color: 'white') }
  let(:white_pawn2) { Pawn.new(color: 'white') }
  let(:black_pawn) { Pawn.new(color: 'black') }

  context 'white pawn1 is in front of white pawn2' do
    row_pawn1 = 7
    row_pawn2 = 6
    col_pawn = 3

    it 'should not let white pawn1 move forward' do
      chess_board.place(white_pawn1, row_pawn1, col_pawn)
      chess_board.place(white_pawn2, row_pawn2, col_pawn)
      expected = white_pawn1.path_valid?(chess_board, row_pawn1, col_pawn, row_pawn2, col_pawn)

      expect(expected).to be false
    end
  end

  context 'when black pawn is at top left corner of white pawn1' do
    row_pawn_white = 7
    col_pawn_white = 5
    row_pawn_black = 6
    col_pawn_black = 4

    it "should let white pawn1 move to black pawn's slot" do
      chess_board.place(white_pawn1, row_pawn_white, col_pawn_white)
      chess_board.place(black_pawn, row_pawn_black, col_pawn_black)
      expected = white_pawn1.path_valid?(chess_board, row_pawn_white, col_pawn_white, row_pawn_black, col_pawn_black)

      expect(expected).to be true
    end

    it 'should let white pawn1 kill black pawn' do
      chess_board.place(white_pawn1, row_pawn_white, col_pawn_white)
      chess_board.place(black_pawn, row_pawn_black, col_pawn_black)
      chess_board.move_piece(row_pawn_white, col_pawn_white, row_pawn_black, col_pawn_black)
      expected = black_pawn.dead

      expect(expected).to be true
    end
  end
end

# Integration tests between boards and rooks
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_rook1) { Rook.new(color: 'white') }
  let(:white_rook2) { Rook.new(color: 'white') }
  let(:black_rook) { Rook.new(color: 'black') }

  context 'white rook1 is in front of white rook2' do
    row_rook1 = 7
    row_rook2 = 6
    col_rook = 3

    it 'should not let white rook1 move forward' do
      chess_board.place(white_rook1, row_rook1, col_rook)
      chess_board.place(white_rook2, row_rook2, col_rook)
      expected = white_rook1.path_valid?(chess_board, row_rook1, col_rook, row_rook2, col_rook)

      expect(expected).to be false
    end
  end

  context 'when black rook is at top  of white rook1' do
    row_rook_white = 7
    row_rook_black = 6
    col_rook = 4

    it "should let white rook1 move to black rook's slot" do
      chess_board.place(white_rook1, row_rook_white, col_rook)
      chess_board.place(black_rook, row_rook_black, col_rook)
      expected = white_rook1.path_valid?(chess_board, row_rook_white, col_rook, row_rook_black, col_rook)

      expect(expected).to be true
    end

    it 'should let white rook1 kill black rook' do
      chess_board.place(white_rook1, row_rook_white, col_rook)
      chess_board.place(black_rook, row_rook_black, col_rook)
      chess_board.move_piece(row_rook_white, col_rook, row_rook_black, col_rook)
      expected = black_rook.dead

      expect(expected).to be true
    end
  end
end

# Integration tests between boards and knights
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_knight1) { Knight.new(color: 'white') }
  let(:white_knight2) { Knight.new(color: 'white') }
  let(:black_knight) { Knight.new(color: 'black') }

  context "white knight1 is at white knight2's destination" do
    row_knight1 = 5
    col_knight1 = 3
    row_knight2 = 3
    col_knight2 = 2

    it 'should not let white knight1 move' do
      chess_board.place(white_knight1, row_knight1, col_knight1)
      chess_board.place(white_knight2, row_knight2, col_knight2)
      expected = white_knight1.path_valid?(chess_board, row_knight1, col_knight1, row_knight2, col_knight2)

      expect(expected).to be false
    end
  end

  context "black knight is at white knight1's destination" do
    row_knight_white = 5
    col_knight_white = 3
    row_knight_black = 3
    col_knight_black = 2

    it 'should let white knight1 move' do
      chess_board.place(white_knight1, row_knight_white, col_knight_white)
      chess_board.place(black_knight, row_knight_black, col_knight_black)
      expected = white_knight1.path_valid?(chess_board, row_knight_white, col_knight_white, row_knight_black, col_knight_black)

      expect(expected).to be true
    end

    it 'should let white knight1 kill black knight' do
      chess_board.place(white_knight1, row_knight_white, col_knight_white)
      chess_board.place(black_knight, row_knight_black, col_knight_black)
      chess_board.move_piece(row_knight_white, col_knight_white, row_knight_black, col_knight_black)
      expected = black_knight.dead

      expect(expected).to be true
    end
  end
end
