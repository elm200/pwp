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
    buf = []
    buf.push '<p>'
    buf.concat @reader.take_block(@marker)
    buf.push '</p>'
    buf
  end
end
