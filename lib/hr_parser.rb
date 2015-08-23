require_relative './parser'

class HrParser < Parser
  def initialize(reader)
    super(reader)
    @marker = /\A----/
  end

  def parse
    super
    %w(<hr />)
  end
end
