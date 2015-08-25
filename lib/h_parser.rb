# require_relative './parser'

# class HParser < Parser
#   def initialize(reader)
#     super(reader)
#     @marker = /\A\*/
#     @h_start_level = 2
#   end
#
#   def parse
#     line = @reader.take
#     level = @h_start_level + (line.slice(/\A\*{1,4}/).length - 1)
#     content = line.sub(/\A\*+/, '')
#     %W(<h#{level}>#{helper.parse_inline(content)}</h#{level}>)
#   end
# end
