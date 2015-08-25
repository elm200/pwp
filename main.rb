require_relative 'lib/puki_wiki_producer'

class Main
  def parse(body, page_names)
    PukiWikiProducer.new(body).to_html
  end

  def run
    body = File.read(File.expand_path('../data/input.puki', __FILE__))
    page_names = ['文法', '自動リンク']
    puts parse(body, page_names)
  end
end

Main.new.run
