require_relative './parser'

class QuoteParser < Parser
  def initialize(reader)
    super(reader)
    @marker = /\A>/
  end

  def parse
    lines = @reader.take_block(@marker)
    ['<blockquote><p>', lines.join("\n"), '</p></blockquote>']
  end
end
