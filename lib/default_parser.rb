require_relative './parser'

class DefaultParser < Parser
  def initialize(reader)
    super(reader)
    @marker = /\A(?![*\s>:\-\+]|----|\z)/
  end

  def match?
    true
  end

  def parse
    lines = @reader.take_block(@marker)
    buf = []
    buf.push '<p>'
    buf.concat parse_p(lines)
    buf.push '</p>'
    buf
  end

  private

  def parse_p(lines)
    lines.map { |line| helper.parse_inline(line) }
  end
end
