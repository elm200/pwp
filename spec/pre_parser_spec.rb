require_relative './spec_helper'

describe 'PreParser' do
  let(:reader) { SourceReader.new(src) }
  let(:parser) { PreParser.new(reader) }
  let(:src) { " abc\ndef" }

  describe '#initialize' do
    it 'assigns @marker' do
      expect(parser.instance_variable_get(:@marker)).not_to be_nil
    end
  end

  describe '#match?' do
    context 'matched' do
      let(:src) { " \nb\n" }
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
    let(:src) { " abc\n def\nhij" }
    it 'collects the lines that match @marker' do
      expect(parser.parse).to eq(%W(<pre><code>abc\ndef </code></pre>))
    end
  end
end
