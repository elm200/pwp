require_relative './html_utils'

class Parser
  include HTMLUtils
  attr_reader :helper

  def initialize(reader)
    @reader = reader
    @helper = ParseHelper.new
  end

  def match?
    @marker =~ @reader.first
  end

  def parse
    [@reader.take]
  end
end
