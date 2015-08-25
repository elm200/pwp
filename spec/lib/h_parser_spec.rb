require_relative '../spec_helper'

describe 'HParser' do
  let(:src) { '*' }
  let(:reader) { SourceReader.new(src) }
  let(:parser) { HParser.new(reader) }

  describe '#initialize' do
    it 'assigns @marker' do
      expect(parser.instance_variable_get(:@marker)).not_to be_nil
      expect(parser.instance_variable_get(:@h_start_level)).not_to be_nil
    end
  end

  describe '#parse' do
    shared_examples_for 'returning a proper heading tag' do
      let(:lines) { reader.instance_variable_get(:@lines) }
      it 'returns a proper h(n) tag' do
        expect(parser.parse).to eq(expected)
        expect(lines.size).to eq(1)
      end
    end

    context 'h2' do
      let(:src) { "*abc\ndef" }
      let(:expected) { %w(<h2>abc</h2>) }
      it_behaves_like 'returning a proper heading tag'
    end

    context 'h3' do
      let(:src) { "**abc\ndef" }
      let(:expected) { %w(<h3>abc</h3>) }
      it_behaves_like 'returning a proper heading tag'
    end

    context 'h4' do
      let(:src) { "***abc\ndef" }
      let(:expected) { %w(<h4>abc</h4>) }
      it_behaves_like 'returning a proper heading tag'
    end

    context 'h5' do
      let(:src) { "****abc\ndef" }
      let(:expected) { %w(<h5>abc</h5>) }
      it_behaves_like 'returning a proper heading tag'
    end

    context 'more than four asterisks' do
      let(:src) { "*****abc\ndef" }
      let(:expected) { %w(<h5>abc</h5>) }
      it_behaves_like 'returning a proper heading tag'
    end
  end
end
