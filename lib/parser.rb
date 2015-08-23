require_relative './html_utils'

class Parser
  include HTMLUtils

  def initialize(reader)
    @reader = reader
  end

  def match?
    @marker =~ @reader.first
  end

  def parse
    [@reader.take]
  end
end
