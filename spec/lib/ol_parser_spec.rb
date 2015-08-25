require_relative '../spec_helper'

describe 'OlParser' do
  let(:reader) { SourceReader.new(src) }
  let(:parser) { OlParser.new(reader) }

  describe '#initialize' do
    shared_examples_for 'assigning instance variables' do
      it 'assigns @type' do
        expect(parser.instance_variable_get(:@type)).to eq(type)
      end

      it 'assigns @marker' do
        expect(parser.instance_variable_get(:@marker)).to eq(marker)
      end
    end

    context 'ol' do
      let(:src) { "+a\ndef" }
      let(:type)  { 'ol' }
      let(:marker) { /\A\+/ }
      it_behaves_like 'assigning instance variables'
    end
  end
end
