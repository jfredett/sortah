require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

desc "Run specs"
RSpec::Core::RakeTask.new

desc "Generate code coverage"
RSpec::Core::RakeTask.new(:coverage) do |t|
  t.rcov = true
  t.rcov_opts = ['--exclude', 'spec']
end
