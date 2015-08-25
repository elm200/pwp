require_relative './parser'

class ListParser < Parser
  def initialize(reader, type)
    super(reader)
    @type = type
    @marker =
      case type
      when 'ul' then /\A-/
      when 'ol' then /\A\+/
      else raise 'unknown type'
      end
  end

  def parse
    parse_list(@reader)
  end

  private

  def parse_list(reader)
    lines = reader.take_block(@marker)
    buf = ["<#{@type}>"]
    closeli = nil
    until lines.empty?
      if @marker =~ lines.first
        new_reader = SourceReader.new(lines)
        buf.concat parse_list(new_reader)
      else
        buf.push closeli if closeli
        closeli = '</li>'
        buf.push "<li>#{helper.parse_inline(lines.shift)}"
      end
    end
    buf.push closeli if closeli
    buf.push "</#{@type}>"
    buf
  end
end
