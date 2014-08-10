require 'rspec_api_documentation'

RspecApiDocumentation.configure do |config|
  # Output folder. The aim here is to output to the engine's directory in dev.
  # Not sure if it will work: might screw with RspecApiDocumentation in the host app too.
  config.docs_dir = Junket::Engine.root.join('doc', 'api')
end