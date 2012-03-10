require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

task :default => :spec

desc "Run specs"
RSpec::Core::RakeTask.new

task :profile do
  ENV["PROFILE"] = "true"
  Rake::Task['spec'].invoke
  system 'rubydeps'
  system 'dot -Tsvg rubydeps.dot > rubydeps.svg'
  system 'open rubydeps.svg'
end

task :clean do
  system 'rm -f rubydeps.dump rubydeps.dot rubydeps.svg'
end

task :c => :console
desc "start up a irb console"
task :console do
  system 'bundle exec irb'
end
