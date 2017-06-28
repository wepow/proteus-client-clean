Gem::Specification.new do |s|
  s.name        = 'proteus_client_clean'
  s.version     = '1.0.1'
  s.summary     = "Ruby client to use proteus rest service"a
  s.description = "It provides an interface to use proteus features"
  s.authors     = %w(andresf)
  s.email       = 'andres@wepow.com'
  s.files       = Dir['lib/proteus_client/representers/*.rb'] +
                  Dir['lib/proteus_client/models/*.rb'] +
                  Dir['lib/proteus_client/*.rb'] +
                  %w(lib/proteus_client.rb) 
  s.homepage    = 'https://github.com/wepow/proteus_client_clean'

  s.add_runtime_dependency "json", "~> 1.7"
  s.add_runtime_dependency "rest-client", "~> 1.6.7"
end
