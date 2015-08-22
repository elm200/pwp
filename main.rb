require './pukiwikiparser.rb'

class DummyLogger
  def debug(msg)
    #$stderr.puts msg
  end
end

def parse2(body, page_names)
  logger = DummyLogger.new
  PukiWikiParser.new(logger).to_html(body, page_names)
end

def main
  body = File.read('./input.puki')
  page_names = ['文法', '自動リンク']
  puts parse2(body, page_names)
end

main
