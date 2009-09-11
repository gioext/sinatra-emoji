Gem::Specification.new do |s|
  s.platform = Gem::Platform::RUBY
  s.name = "sinatra-emoji"
  s.version = "0.1.3"
  s.date = "2009-09-12"
  s.authors = ["gioext"]
  s.email = "gioext@gmail.com"
  s.homepage = "http://github.com/gioext/sinatra-emoji"
  s.summary = "Mobile emoji on Sinatra"

  s.files = [
    "README.textile",
    "lib/sinatra/emoji.rb",
  ]

  s.require_paths = ["lib"]
  s.add_dependency "sinatra"

  s.has_rdoc = "false"
end
