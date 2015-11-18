# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sacsp_gateway/version'

Gem::Specification.new do |spec|
  spec.name          = "sacsp_gateway"
  spec.version       = SacspGateway::VERSION
  spec.authors       = ["Marcelo Menezes"]
  spec.email         = ["gnumarcelo@gmail.com"]

  spec.summary       = %q{Criação de chamados no SAC da Prefeitura de São Paulo.}
  spec.description   = %q{Gem EXPERIMENTAL para criação de chamados no SAC da Prefeitura de São Paulo.}
  spec.homepage      = "https://github.com/gnumarcelo/sacsp_gateway"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2'
  spec.add_dependency 'mechanize'
  spec.add_dependency 'faraday'
  spec.add_dependency 'faraday-cookie_jar'
  spec.add_dependency 'faraday_middleware'
  spec.add_dependency 'nokogiri'

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'vcr', '~> 2'
  spec.add_development_dependency 'webmock'
  #spec.add_development_dependency 'debugger'

end