require_relative './parser'

class EmptyParser < Parser
  def match?
    '' == @reader.first
  end

  def parse
    super
    [nil]
  end
end
