require_relative './list_parser'

class UlParser < ListParser
  def initialize(reader)
    super(reader, 'ul')
  end
end
