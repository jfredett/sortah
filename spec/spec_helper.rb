require 'rspec'

require './lib/sortah' 

require 'pry'

if ENV["PROFILE"]
  require 'rubydeps'
  Rubydeps.start
end
