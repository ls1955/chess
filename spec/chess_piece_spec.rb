# frozen_string_literal: false

require_relative './../lib/chess_piece'

describe BasicChessPiece do
  let(:black_chess_piece1) { described_class.new(color: 'black') }
  let(:black_chess_piece2) { described_class.new(color: 'black') }
  let(:white_chess_piece1) { described_class.new(color: 'white') }

  describe '#ally?' do
    it 'return true if they have same color' do
      result = black_chess_piece1.ally?(black_chess_piece2)
      expect(result).to be true
    end

    it 'return false if they have different color' do
      result = black_chess_piece1.ally?(white_chess_piece1)
      expect(result).to be false
    end
  end
end

describe Pawn do
  let(:old_row) { 7 }
  let(:old_col) { 3 }
  let(:pawn) { described_class.new(color: 'white') }

  describe '#reachable?' do
    it 'can move one step up' do
      new_row = 6
      result = pawn.reachable?(old_row, old_col, new_row, old_col)
      expect(result).to be true
    end

    it 'cannot move one step down' do
      new_row = 8
      result = pawn.reachable?(old_row, old_col, new_row, old_col)
      expect(result).to be false
    end

    it 'can move two step up if it is first step' do
      pawn.instance_variable_set(:@had_move_once, false)
      new_row = 5
      result = pawn.reachable?(old_row, old_col, new_row, old_col)
      expect(result).to be true
    end

    it 'cannot move two step up if it is not first step' do
      pawn.instance_variable_set(:@had_move_once, true)
      new_row = 5
      result = pawn.reachable?(old_row, old_col, new_row, old_col)
      expect(result).to be false
    end
  end
end

describe Rook do
  subject(:rook) { described_class.new(color: 'white') }
  let(:old_row) { 7 }
  let(:old_col) { 7 }

  describe '#reachable?' do
    it 'can move 7 step up' do
      new_row = 0
      result = rook.reachable?(old_row, old_col, new_row, old_col)

      expect(result).to be true
    end

    it 'can move 7 step left' do
      new_col = 0
      result = rook.reachable?(old_row, old_col, old_row, new_col)

      expect(result).to be true
    end

    it 'cannot move 1 step up and left at the same time' do
      new_row = 6
      new_col = 6
      result = rook.reachable?(old_row, old_col, new_row, new_col)

      expect(result).to be false
    end
  end
end

describe Bishop do
  subject(:bishop) { described_class.new(color: 'white') }
  let(:old_row) { 7 }
  let(:old_col) { 7 }

  describe '#reachable?' do
    it 'cannot move 7 step up' do
      new_row = 0
      result = bishop.reachable?(old_row, old_col, new_row, old_col)

      expect(result).to be false
    end

    it 'cannot move 7 step left' do
      new_col = 0
      result = bishop.reachable?(old_row, old_col, old_row, new_col)

      expect(result).to be false
    end

    it 'can move 7 step up and left at the same time' do
      new_row = 0
      new_col = 0
      result = bishop.reachable?(old_row, old_col, new_row, new_col)

      expect(result).to be true
    end
  end
end

describe Queen do
  subject(:queen) { described_class.new(color: 'white') }
  let(:old_row) { 7 }
  let(:old_col) { 7 }

  describe '#reachable?' do
    it 'can move 7 step up' do
      new_row = 0
      result = queen.reachable?(old_row, old_col, new_row, old_col)

      expect(result).to be true
    end

    it 'can move 7 step left' do
      new_col = 0
      result = queen.reachable?(old_row, old_col, old_row, new_col)

      expect(result).to be true
    end

    it 'can move 1 step up and left at the same time' do
      new_row = 6
      new_col = 6
      result = queen.reachable?(old_row, old_col, new_row, new_col)

      expect(result).to be true
    end

    it 'cannot move 1 step up and 2 step left at the same time' do
      new_row = 6
      new_col = 5
      result = queen.reachable?(old_row, old_col, new_row, new_col)

      expect(result).to be false
    end
  end
end

describe King do
  subject(:king) { described_class.new(color: 'white') }
  let(:old_row) { 7 }
  let(:old_col) { 7 }

  describe '#reachable?' do
    it 'can move 1 step up' do
      new_row = 6
      result = king.reachable?(old_row, old_col, new_row, old_col)

      expect(result).to be true
    end

    it 'can move 1 step left' do
      new_col = 6
      result = king.reachable?(old_row, old_col, old_row, new_col)

      expect(result).to be true
    end

    it 'can move 1 step up and left at the same time' do
      new_row = 6
      new_col = 6
      result = king.reachable?(old_row, old_col, new_row, new_col)

      expect(result).to be true
    end

    it 'cannot move 2 step up' do
      new_row = 5
      result = king.reachable?(old_row, old_col, new_row, old_col)

      expect(result).to be false
    end
  end
end
