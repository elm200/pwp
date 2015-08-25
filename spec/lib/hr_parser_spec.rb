require_relative '../spec_helper'

describe 'HrParser' do
  let(:src) { '----' }
  let(:reader) { SourceReader.new(src) }
  let(:parser) { HrParser.new(reader) }

  describe '#initialize' do
    it 'assigns @marker' do
      expect(parser.instance_variable_get(:@marker)).not_to be_nil
    end
  end

  describe '#match?' do
    context 'matched' do
      it 'returns truthy if the first line matches @marker' do
        expect(parser.match?).to be_truthy
      end
    end

    context 'unmatched' do
      let(:src) { "a\nb\n" }
      it 'returns falsy if the first line does not match @marker' do
        expect(parser.match?).to be_falsy
      end
    end
  end

  describe '#parse' do
    let(:src) { "----\nabc" }
    let(:lines) { reader.instance_variable_get(:@lines) }
    it 'collects the lines that match @marker' do
      expect(parser.parse).to eq(['<hr />'])
      expect(lines.size).to eq(1)
    end
  end
end
