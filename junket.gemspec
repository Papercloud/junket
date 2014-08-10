$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'junket/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'junket'
  s.version     = Junket::VERSION
  s.authors     = ['Tom Spacek']
  s.email       = ['ts@papercloud.com.au']
  s.homepage    = 'http://www.papercloud.com.au'
  s.summary     = 'Power email and SMS campaigns in multi-tenant apps.'
  s.description = 'Manage campaign templates, target users, send mail and SMS, and collect reporting.'
  s.license     = 'MIT'

  s.files = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.rdoc']

  s.add_dependency 'rails', '>= 3.2'
  s.add_dependency 'liquid', '>= 2.6.1'
  s.add_dependency 'responders'
  s.add_dependency 'cancancan', '~> 1.9'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'shoulda'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'thor', '0.19.1'
  s.add_development_dependency 'terminal-notifier-guard'
  s.add_development_dependency 'rspec_api_documentation'
end
