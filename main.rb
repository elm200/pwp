require './pukiwikiparser.rb'
require './dummy_logger.rb'

class Main
  def parse(body, page_names)
    logger = DummyLogger.new
    PukiWikiParser.new(logger).to_html(body, page_names)
  end

  def run
    body = File.read('./input.puki')
    page_names = ['文法', '自動リンク']
    puts parse(body, page_names)
  end
end

Main.new.run
