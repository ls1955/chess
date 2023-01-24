# frozen_string_literal: true

require_relative './../lib/chess_board'
require_relative './../lib/chess_piece'

describe ChessBoard do
  subject(:chess_board) { described_class.new }
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

      expect(chess_board.layout).to eq(expected)
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

      expect(chess_board.to_s).to eq(expected)
    end
  end

  describe '#chess_piece' do
    it 'return the chess at given row and column index' do
      chess_board.place(chess_piece, 0, 0)

      expected = chess_board.chess_piece(0, 0)

      expect(expected).to be chess_piece
    end
  end

  describe '#has_promote?' do
    it 'return false if no pawn reach the first row' do
      chess_board.place_chess_pieces_at_begin
      result = chess_board.has_promote?

      expect(result).to be false
    end

    it 'return true if pawn reach the first row' do
      white_pawn = Pawn.new(color: 'white')
      row_pawn_white = 0
      col_pawn_white = 0
      chess_board.place(white_pawn, row_pawn_white, col_pawn_white)
      result = chess_board.has_promote?

      expect(result).to be true
    end
  end

  describe '#in_check?' do
    subject(:white_king) { King.new(color: 'white') }
    subject(:black_queen) { Queen.new(color: 'black') }
    subject(:black_pawn) { Pawn.new(color: 'black') }

    context 'when black queen is beside white king' do
      it 'is in check' do
        row_king_white = 0
        col_king_white = 0
        row_queen_black = 0
        col_queen_black = 1
        chess_board.place(white_king, row_king_white, col_king_white)
        chess_board.place(black_queen, row_queen_black, col_queen_black)
        result = chess_board.in_check?(curr_color: 'white', enemy_color: 'black')

        expect(result).to be true
      end
    end

    context 'when white king is not in range of black king' do
      it 'should not in check' do
        row_king_white = 0
        col_king_white = 0
        row_queen_black = 7
        col_queen_black = 6
        chess_board.place(white_king, row_king_white, col_king_white)
        chess_board.place(black_queen, row_queen_black, col_queen_black)
        result = chess_board.in_check?(curr_color: 'white', enemy_color: 'black')

        expect(result).to be false
      end
    end

    context 'when white king is behind black pawn' do
      it 'should not in check' do
        row_pawn_black = 1
        col_pawn_black = 1
        row_king_white = 0
        col_king_white = 0
        chess_board.place(white_king, row_king_white, col_king_white)
        chess_board.place(black_pawn, row_pawn_black, col_pawn_black)
        result = chess_board.in_check?(curr_color: 'white', enemy_color: 'black')

        expect(result).to be false
      end
    end
  end

  describe '#move_piece' do
    context 'when given a chess piece previous and new row and column index' do
      it 'moves the chess to desirable slot' do
        chess_board.place(chess_piece, 7, 0)
        chess_board.move_piece(7, 0, 6, 0)

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

        expect(chess_board.to_s).to eq(expected)
      end
    end
  end

  describe '#occupy?' do
    context 'when given a row and column index' do
      it 'return true if slot is occupy' do
        chess_board.place(chess_piece, 3, 5)

        expect(chess_board.occupy?(3, 5)).to be true
      end

      it 'return false if slot is not occupy' do
        chess_board.place(chess_piece, 3, 7)

        expect(chess_board.occupy?(3, 5)).to be false
      end
    end
  end

  describe '#place' do
    context 'when given a chess piece row and column index' do
      it 'place the chess at desirable slot' do
        chess_board.place(chess_piece, 7, 0)

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

        expect(chess_board.to_s).to eq(expected)
      end
    end
  end

  describe '#place_chess_pieces_at_begin' do
    it 'place the chess pieces at the beginning' do
      chess_board.place_chess_pieces_at_begin

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

      expect(chess_board.to_s).to eq(expected)
    end
  end

  describe '#unoccupy?' do
    context 'when given a row and column index' do
      it 'return true if there is no chess piece' do
        row = 0
        col = 0

        expected = chess_board.unoccupy?(row, col)

        expect(expected).to be true
      end

      it 'return false if there is chess piece' do
        row = 0
        col = 0
        chess_board.place(chess_piece, 0, 0)

        expected = chess_board.unoccupy?(row, col)

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
  end

  describe '#turn_around' do
    context 'after the board is turn around' do
      it 'shows the view from other side' do
        chess_board.place_chess_pieces_at_begin
        chess_board.turn_around
        view = chess_board.to_s
        expected = <<~BOARD
             a b c d e f g h
          8 |♖|♘|♗|♔|♕|♗|♘|♖| 8
          7 |♙|♙|♙|♙|♙|♙|♙|♙| 7
          6 | | | | | | | | | 6
          5 | | | | | | | | | 5
          4 | | | | | | | | | 4
          3 | | | | | | | | | 3
          2 |♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎|♟︎| 2
          1 |♜|♞|♝|♚|♛|♝|♞|♜| 1
            -----------------
             a b c d e f g h
        BOARD
        expect(expected).to eq(view)
      end
    end
  end
end

# Integration tests between boards and rooks
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_rook1) { Rook.new(color: 'white') }
  let(:white_rook2) { Rook.new(color: 'white') }
  let(:black_rook1) { Rook.new(color: 'black') }
  let(:black_rook2) { Rook.new(color: 'black') }

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

  context 'when black rook1 is at top of white rook1' do
    row_rook_white = 7
    row_rook_black = 6
    col_rook = 4

    it "should let white rook1 move to black rook1's slot" do
      chess_board.place(white_rook1, row_rook_white, col_rook)
      chess_board.place(black_rook1, row_rook_black, col_rook)
      expected = white_rook1.path_valid?(chess_board, row_rook_white, col_rook, row_rook_black, col_rook)

      expect(expected).to be true
    end
  end

  context 'when black rook1 is in front black rook2, white rook move to black rook2' do
    row_rook_white = 7
    row_rook1_black = 6
    row_rook2_black = 5
    col_rook = 4

    it "should not let white rook1 move to black rook2's slot" do
      chess_board.place(white_rook1, row_rook_white, col_rook)
      chess_board.place(black_rook1, row_rook1_black, col_rook)
      chess_board.place(black_rook2, row_rook2_black, col_rook)
      expected = white_rook1.path_valid?(chess_board, row_rook_white, col_rook, row_rook2_black, col_rook)

      expect(expected).to be false
    end
  end
end

# Integration tests between boards and knights
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_knight1) { Knight.new(color: 'white') }
  let(:white_knight2) { Knight.new(color: 'white') }
  let(:black_knight) { Knight.new(color: 'black') }

  context "white knight2 is at white knight1's destination" do
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
  end
end

# Integration tests between board and bishop
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_bishop1) { Bishop.new(color: 'white') }
  let(:white_bishop2) { Bishop.new(color: 'white') }
  let(:black_bishop) { Bishop.new(color: 'black') }

  context "white bishop2 is at white bishop1's destination" do
    row_bishop1 = 4
    col_bishop1 = 4
    row_bishop2 = 5
    col_bishop2 = 5

    it 'should not let white bishop1 move' do
      chess_board.place(white_bishop1, row_bishop1, col_bishop1)
      chess_board.place(white_bishop2, row_bishop2, col_bishop2)
      expected = white_bishop1.path_valid?(chess_board, row_bishop1, col_bishop1, row_bishop2, col_bishop2)

      expect(expected).to be false
    end
  end

  context "black bishop is at white bishop1's destination" do
    row_bishop_white = 4
    col_bishop_white = 4
    row_bishop_black = 5
    col_bishop_black = 5

    it 'should let white bishop1 move' do
      chess_board.place(white_bishop1, row_bishop_white, col_bishop_white)
      chess_board.place(black_bishop, row_bishop_black, col_bishop_black)
      expected = white_bishop1.path_valid?(chess_board, row_bishop_white, col_bishop_white, row_bishop_black, col_bishop_black)

      expect(expected).to be true
    end
  end
end

# Integration tests between board and queen
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_queen1) { Queen.new(color: 'white') }
  let(:white_queen2) { Queen.new(color: 'white') }
  let(:black_queen) { Queen.new(color: 'black') }

  context "white queen2 is at white queen1's destination" do
    row_queen1 = 4
    col_queen1 = 4
    row_queen2 = 5
    col_queen2 = 5

    it 'should not let white queen1 move' do
      chess_board.place(white_queen1, row_queen1, col_queen1)
      chess_board.place(white_queen2, row_queen2, col_queen2)
      expected = white_queen1.path_valid?(chess_board, row_queen1, col_queen1, row_queen2, col_queen2)

      expect(expected).to be false
    end
  end

  context 'white queen2 is in front of white queen1 while white queen1 move forward' do
    row_queen1 = 4
    row_queen2 = 3
    col_queen = 5

    it 'should not let white queen1 move' do
      chess_board.place(white_queen1, row_queen1, col_queen)
      chess_board.place(white_queen2, row_queen2, col_queen)
      expected = white_queen1.path_valid?(chess_board, row_queen1, col_queen, row_queen2, col_queen)

      expect(expected).to be false
    end
  end

  context "black queen is at white queen1's destination" do
    row_queen_white = 4
    col_queen_white = 4
    row_queen_black = 5
    col_queen_black = 5

    it 'should let white queen1 move' do
      chess_board.place(white_queen1, row_queen_white, col_queen_white)
      chess_board.place(black_queen, row_queen_black, col_queen_black)
      expected = white_queen1.path_valid?(chess_board, row_queen_white, col_queen_white, row_queen_black, col_queen_black)

      expect(expected).to be true
    end
  end
end

# Integration test between board and king
describe ChessBoard do
  subject(:chess_board) { described_class.new }
  let(:white_king1) { King.new(color: 'white') }
  let(:white_king2) { King.new(color: 'white') }
  let(:black_king) { King.new(color: 'black') }

  context "white king2 is at white king1's destination" do
    row_king1 = 4
    row_king2 = 5
    col_king = 5

    it 'should not let white king1 move' do
      chess_board.place(white_king1, row_king1, col_king)
      chess_board.place(white_king2, row_king2, col_king)
      expected = white_king1.path_valid?(chess_board, row_king1, col_king, row_king2, col_king)

      expect(expected).to be false
    end
  end

  context 'white king2 is in front of white king1 while white king1 move forward' do
    row_king1 = 4
    row_king2 = 3
    col_king = 5

    it 'should not let white king1 move' do
      chess_board.place(white_king1, row_king1, col_king)
      chess_board.place(white_king2, row_king2, col_king)
      expected = white_king1.path_valid?(chess_board, row_king1, col_king, row_king2, col_king)

      expect(expected).to be false
    end
  end

  context "black king is at white king1's destination" do
    row_king_white = 4
    row_king_black = 5
    col_king = 5

    it 'should let white king1 move' do
      chess_board.place(white_king1, row_king_white, col_king)
      chess_board.place(black_king, row_king_black, col_king)
      expected = white_king1.path_valid?(chess_board, row_king_white, col_king, row_king_black, col_king)

      expect(expected).to be true
    end
  end
end
