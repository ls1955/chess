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
