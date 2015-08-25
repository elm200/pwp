require_relative '../spec_helper'

describe 'SourceReader' do
  let(:src) { "abc\ndef" }
  let(:reader) { SourceReader.new(src) }
  let(:lines) { reader.instance_variable_get(:@lines) }

  describe '#initialize' do
    shared_examples_for 'assigning @lines' do
      it 'assigns @lines' do
        expect(lines).to eq(expected)
      end
    end

    context 'src is a string' do
      let(:expected) { %w(abc def) }
      it_behaves_like 'assigning @lines'
    end

    context 'src is an array' do
      let(:src) { %w(abc def) }
      let(:expected) { %w(abc def) }
      it_behaves_like 'assigning @lines'
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
