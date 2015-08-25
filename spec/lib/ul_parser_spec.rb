require_relative '../spec_helper'

describe 'UlParser' do
  let(:reader) { SourceReader.new(src) }
  let(:parser) { UlParser.new(reader) }

  describe '#initialize' do
    shared_examples_for 'assigning instance variables' do
      it 'assigns @type' do
        expect(parser.instance_variable_get(:@type)).to eq(type)
      end

      it 'assigns @marker' do
        expect(parser.instance_variable_get(:@marker)).to eq(marker)
      end
    end

    context 'ul' do
      let(:src) { "-a\ndef" }
      let(:type)  { 'ul' }
      let(:marker) { /\A-/ }
      it_behaves_like 'assigning instance variables'
    end
  end
end
