require 'bundler/gem_tasks'
require 'rake'
require 'rake/testtask'

desc "Run all tests"
Rake::TestTask.new do |t|
  t.test_files = FileList['test/*_test.rb']
  t.verbose = true
end
