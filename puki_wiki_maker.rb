Dir[File.expand_path('../lib', __FILE__) << '/*.rb'].each do |file|
  require file
end

class PukiWikiMaker
  def initialize(src)
    @reader = SourceReader.new(src)
    @parsers = []
    @parsers.push(EmptyParser.new(@reader))
    @parsers.push(PreParser.new(@reader))
    @parsers.push(DefaultParser.new(@reader))
  end

  def to_html
    buf = []
    buf.concat(@parsers.find(&:match?).parse) until @reader.eof?
    buf.reject(&:nil?).join("\n")
  end
end