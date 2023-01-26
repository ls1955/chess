# frozen_string_literal: false

require_relative './../lib/chess'
require 'yaml'

describe Chess do
  subject(:chess) { described_class.new }

  describe '#valid?' do
    # for more info regarding chess notation, please visit: https://en.wikipedia.org/wiki/Chess#Notation
    context 'when user enter a valid chess notation coordinate' do
      it 'return true' do
        input_valid = 'a1'
        expect(chess.valid?(input_valid)).to be true
      end
    end

    context 'whe user enter an invalid chess notation coordinate' do  
      it 'return false' do
        input_invalid = 'Aquamarine'
        expect(chess.valid?(input_invalid)).to be false
      end
    end
  end

  describe '#input2row_col' do
    it 'turn a8 into [0, 0]' do
      input = 'a8'
      row, col = chess.input2row_col(input)

      expect(row).to eq(0)
      expect(col).to eq(0)
    end

    it 'turn h8 into [0, 7]' do
      input = 'h8'
      row, col = chess.input2row_col(input)

      expect(row).to eq(0)
      expect(col).to eq(7)
    end
  end
end
