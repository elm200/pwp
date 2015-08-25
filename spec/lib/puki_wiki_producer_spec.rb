require_relative '../spec_helper'

describe 'PukiWikiMaker' do
  let(:maker) { PukiWikiMaker.new(src) }

  describe '#initialize' do
    let(:src) { '' }
    let(:parsers) { maker.instance_variable_get(:@parsers) }

    it 'assigns parsers' do
      expect(parsers.size > 0).to be_truthy
    end
  end

  describe '#to_html' do
    let(:src) { " a\n b\n\nc\n" }

    it 'converts the source text to HTML' do
      expect(maker.to_html).to eq("<pre><code>a\nb\n</code></pre>\n<p>\nc\n</p>")
    end
  end
end
