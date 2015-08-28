require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

Dir[File.expand_path('../../lib', __FILE__) << '/*.rb'].each do |file|
  require file
end
