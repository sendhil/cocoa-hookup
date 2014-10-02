Gem::Specification.new do |s|
  s.name          = 'cocoa-hookup'
  s.version       = '0.0.3'
  s.platform      = Gem::Platform::RUBY
  s.date          = '2014-10-01'
  s.summary       = "Simplify the Cocoapods dance that occurs when switching between branches"
  s.description   = "Simplify the Cocoapods dance that occurs when switching between branches"
  s.authors       = ["Sendhil Panchadsaram"]
  s.email         = 'sendh' + 'ilp@gmail.com'
  s.homepage      = 'http://rubygems.org/gems/cocoa-hookup'
  s.license       = 'MIT'
  s.files         = ["lib/cocoa-hookup.rb"]
  s.executables   = ["cocoa-hookup"]
  s.require_paths = ["lib"]
  
  s.add_runtime_dependency 'terminal-notifier', '~> 1.6.1'
end
