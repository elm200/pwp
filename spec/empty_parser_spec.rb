require_relative './spec_helper'

describe 'EmptyParser' do
  let(:reader) { SourceReader.new(src) }
  let(:parser) { EmptyParser.new(reader) }

  describe '#match?' do
    context 'when true' do
      let(:src) { "\nb\n" }
      it 'returns true if the first line is empty' do
        expect(parser.match?).to be_truthy
      end
    end

    context 'when false' do
      let(:src) { "a\nb\n" }
      it 'returns true if the first line is not empty' do
        expect(parser.match?).to be_falsy
      end
    end
  end
end
