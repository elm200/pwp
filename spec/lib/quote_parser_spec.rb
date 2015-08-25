require_relative '../spec_helper'

describe 'QuoteParser' do
  let(:src) { ">abc\n>def\nhij" }
  let(:reader) { SourceReader.new(src) }
  let(:parser) { QuoteParser.new(reader) }

  describe '#initialize' do
    it 'assigns @marker' do
      expect(parser.instance_variable_get(:@marker)).not_to be_nil
    end
  end

  describe '#parse' do
    let(:lines) { reader.instance_variable_get(:@lines) }
    let(:expected) { ['<blockquote><p>', "abc\ndef", '</p></blockquote>'] }
    it 'returns a blockquote' do
      expect(parser.parse).to eq(expected)
      expect(lines.size).to eq(1)
    end
  end
end
