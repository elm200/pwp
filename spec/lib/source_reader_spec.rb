require_relative '../spec_helper'

describe 'SourceReader' do
  let(:src) { "abc\ndef" }
  let(:reader) { SourceReader.new(src) }
  let(:lines) { reader.instance_variable_get(:@lines) }

  describe '#initialize' do
    it 'assigns @lines' do
      expect(lines).not_to be_nil
      expect(lines).to eq(%w(abc def))
    end
  end

  describe '#eof?' do
    let(:src) { '' }
    it 'return true if lines are empty' do
      expect(reader.eof?).to be true
    end
  end

  describe '#first' do
    it 'returns the first line of the remaining source text' do
      expect(reader.first).to eq('abc')
    end
  end

  describe '#take' do
    it 'take the first line of the remaining source text' do
      expect(reader.take).to eq('abc')
      expect(lines.size).to eq(1)
    end
  end

  describe '#take_block' do
    let(:marker) { /\A\s/ }
    let(:src) { " abc\n def\nhij" }
    it 'take a block while the marker appears' do
      expect(reader.take_block(marker)).to eq(%w(abc def))
    end
  end
end
