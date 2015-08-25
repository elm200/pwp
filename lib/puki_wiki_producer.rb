Dir[File.expand_path('.', __FILE__) << '/*.rb'].each do |file|
  require file
end

class PukiWikiProducer
  def initialize(src)
    @reader = SourceReader.new(src)
    @parsers = [EmptyParser, HrParser, HParser, PreParser, DefaultParser]
               .map { |klass| klass.new(@reader) }
  end

  def to_html
    buf = []
    buf.concat(parsed_block) until @reader.eof?
    buf.reject(&:nil?).join("\n")
  end

  private

  def parsed_block
    @parsers.find(&:match?).parse
  end
end
