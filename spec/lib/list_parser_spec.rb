require_relative '../spec_helper'

describe 'ListParser' do
  let(:reader) { SourceReader.new(src) }
  let(:parser) { ListParser.new(reader, type) }

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

    context 'ol' do
      let(:src) { "+a\ndef" }
      let(:type)  { 'ol' }
      let(:marker) { /\A\+/ }
      it_behaves_like 'assigning instance variables'
    end

    context 'type is something else' do
      let(:src) { ":a\ndef" }
      let(:type)  { 'dl' }

      it 'raises' do
        expect {
          parser
        }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#parse' do
    shared_examples_for 'parsing + or - items' do
      let(:lines) { reader.instance_variable_get(:@lines) }
      it 'returns a ul or an ol block' do
        expect(parser.parse).to eq(expected)
        expect(lines.size).to eq(1)
      end
    end

    context 'ul' do
      let(:src) { "-a\n--b\nc" }
      let(:type) { 'ul' }
      let(:expected) { ["<ul>", "<li>a", "<ul>", "<li>b", "</li>", "</ul>", "</li>", "</ul>"] }
      it_behaves_like 'parsing + or - items'
    end

    context 'ol' do
      let(:src) { "+a\n++b\nc" }
      let(:type) { 'ol' }
      let(:expected) { ["<ol>", "<li>a", "<ol>", "<li>b", "</li>", "</ol>", "</li>", "</ol>"] }
      it_behaves_like 'parsing + or - items'
    end

  end
end
