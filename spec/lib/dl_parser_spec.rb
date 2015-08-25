require_relative '../spec_helper'

describe 'DlParser' do
  let(:src) { ":abc|def\nhij" }
  let(:reader) { SourceReader.new(src) }
  let(:parser) { DlParser.new(reader) }

  describe '#initialize' do
    it 'assigns @marker' do
      expect(parser.instance_variable_get(:@marker)).not_to be_nil
    end
  end

  describe '#parse' do
    let(:lines) { reader.instance_variable_get(:@lines) }
    let(:expected) { %w(<dl> <dt>abc</dt> <dd>def</dd> </dl>) }
    it 'returns a dl block' do
      expect(parser.parse).to eq(expected)
      expect(lines.size).to eq(1)
    end
  end

  context 'private methods' do
    describe '#parse_line' do
      context 'both <dt> and <dd> exist' do
        let(:line) { 'abc|def' }
        let(:expected) { %w(<dt>abc</dt> <dd>def</dd>) }
        it 'returns a pair of <dt> and <dd>.' do
          expect(parser.send(:parse_line, line)).to eq(expected)
        end
      end

      context 'only <dt> exists' do
        let(:line) { 'abc' }
        let(:expected) { %w(<dt>abc</dt>) }
        it 'returns a <dt>.' do
          expect(parser.send(:parse_line, line)).to eq(expected)
        end
      end
    end
  end
end
