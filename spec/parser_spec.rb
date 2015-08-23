require_relative './spec_helper'

describe 'Parser' do
  let(:reader) { SourceReader.new("abc\ndef") }
  let(:parser) { Parser.new(reader) }

  describe '#initialize' do
    it 'assigns @reader' do
      expect(parser.instance_variable_get(:@reader)).not_to be_nil
    end
  end

  describe '#match?' do
    it 'return false if @marker is nil' do
       expect(parser.match?).to be_falsy
    end
  end

  describe '#parse' do
    it 'always takes and returns the first line' do
      expect(parser.parse).to eq(%w(abc))
    end
  end
end
