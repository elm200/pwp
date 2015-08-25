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
    let(:src) { ">a\n-a\n--b\n+c\n++d\n:e|f\n**x\n----\n a\n b\n\nc\n" }
    let(:expected) {
      "<blockquote><p>\na\n</p></blockquote>\n" \
      "<ul>\n<li>a\n<ul>\n<li>b\n</li>\n</ul>\n</li>\n</ul>\n<ol>\n<li>c\n" \
      "<ol>\n<li>d\n</li>\n</ol>\n</li>\n</ol>\n" \
      "<dl>\n<dt>e</dt>\n<dd>f</dd>\n</dl>\n<h3>x</h3>\n" \
      "<hr />\n<pre><code>a\nb\n</code></pre>\n<p>\nc\n</p>"
    }

    it 'converts the source text to HTML' do
      expect(maker.to_html).to eq(expected)
    end
  end
end
