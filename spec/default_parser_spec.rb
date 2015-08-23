require_relative './spec_helper'

describe 'DefaultParser' do
  let(:reader) { SourceReader.new(src) }
  let(:parser) { DefaultParser.new(reader) }
  let(:src) { " abc\ndef" }

  describe '#initialize' do
    it 'assigns @marker' do
      expect(parser.instance_variable_get(:@marker)).not_to be_nil
    end
  end

  describe '#match?' do
    it 'always returns true' do
      expect(parser.match?).to be true
    end
  end

  describe '#parse' do
    let(:src) { "abc\ndef\n hij" }
    it 'collects the lines that match @marker' do
      expect(parser.parse).to eq(%w(<p> abc def </p>))
    end
  end
end
