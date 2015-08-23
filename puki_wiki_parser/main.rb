require_relative './puki_wiki_parser.rb'
require_relative './dummy_logger.rb'

class Main
  def parse(body, page_names)
    logger = DummyLogger.new
    PukiWikiParser.new(logger).to_html(body, page_names)
  end

  def run
    body = File.read(File.expand_path('../../data/input.puki', __FILE__))
    page_names = ['文法', '自動リンク']
    puts parse(body, page_names)
  end
end

Main.new.run
