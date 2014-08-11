begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Junket'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

APP_RAKEFILE = File.expand_path('../spec/dummy/Rakefile', __FILE__)
load 'rails/tasks/engine.rake'

RspecApiDocumentation.configure do |config|
  # Output folder. The aim here is to output to the engine's directory in dev.
  # Not sure if it will work: might screw with RspecApiDocumentation in the host app too.
  config.docs_dir = Junket::Engine.root.join('doc', 'api')
end

Bundler::GemHelper.install_tasks
