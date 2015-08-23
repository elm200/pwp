Dir[File.expand_path('../../lib', __FILE__) << '/*.rb'].each do |file|
  require file
end

require_relative '../puki_wiki_maker.rb'
