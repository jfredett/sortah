# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "sortah/version"

Gem::Specification.new do |s|
  s.name        = "sortah"
  s.version     = Sortah::VERSION
  s.authors     = ["Joe Fredette"]
  s.email       = ["jfredett@gmail.com"]
  s.homepage    = "http://www.github.com/jfredett/sortah"
  s.summary     = %q{For sortin' your email}
  s.description = %q{
    Sortah provides a simple, declarative internal DSL for sorting 
    your email. It provides an executable which may serve as an external
    mail delivery agent for such programs as `getmail`. Finally, since
    your sorting logic is just Plain Old Ruby Code (PORC, as I like to call it).
    You have access to 100% of ruby as needed, including all of it's 
    object oriented goodness, it's wonderful community of gems, and it's 
    powerful metaprogramming ability.
  }

  s.rubyforge_project = "sortah"

  s.add_dependency "mail"
  s.add_dependency "trollop"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
