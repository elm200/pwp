require_relative './parser'

class PreParser < Parser
  def initialize(reader)
    super(reader)
    @marker = /\A\s/
  end

  def match?
    @marker =~ @reader.first
  end

  def parse
    lines = @reader.take_block(@marker)
    ["<pre><code>#{lines.map { |line| escape(line) }.join("\n")}",
     '</code></pre>']
  end
end
