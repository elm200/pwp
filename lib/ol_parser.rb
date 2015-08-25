require_relative './list_parser'

class OlParser < ListParser
  def initialize(reader)
    super(reader, 'ol')
  end
end
