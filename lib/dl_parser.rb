require_relative './parser'

class DlParser < Parser
  def initialize(reader)
    super(reader)
    @marker = /\A:/
  end

  def parse
    lines = @reader.take_block(@marker)
    [].tap do |buf|
      buf.push '<dl>'
      lines.each { |line| buf.concat parse_line(line) }
      buf.push '</dl>'
    end
  end

  private

  def parse_line(line)
    dt, dd = *line.split('|', 2)
    [].tap do |buf|
      buf.push "<dt>#{helper.parse_inline(dt)}</dt>"
      buf.push "<dd>#{helper.parse_inline(dd)}</dd>" if dd
    end
  end
end
