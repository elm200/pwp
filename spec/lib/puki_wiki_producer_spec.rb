require_relative '../spec_helper'

describe 'PukiWikiProducer' do
  let(:maker) { PukiWikiProducer.new(src) }

  describe '#initialize' do
    let(:src) { '' }
    let(:parsers) { maker.instance_variable_get(:@parsers) }

    it 'assigns parsers' do
      expect(parsers.size > 0).to be_truthy
    end
  end

  describe '#to_html' do
    let(:src) { "**x\n----\n a\n b\n\nc\n" }
    let(:expected) { "<h3>x</h3>\n<hr />\n<pre><code>a\nb\n</code></pre>\n<p>\nc\n</p>" }
    it 'converts the source text to HTML' do
      expect(maker.to_html).to eq(expected)
    end
  end
end
