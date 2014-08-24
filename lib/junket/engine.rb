module Junket
  class Engine < ::Rails::Engine
    isolate_namespace Junket

    require 'cancancan'
    require 'active_model_serializers'
    require 'responders'

    config.autoload_paths += %W(#{config.root}/lib)

    config.generators do |g|
      g.hidden_namespaces << :test_unit
      g.test_framework :rspec
      g.factory_girl dir: 'spec/factories'
      g.test_framework :rspec, fixture: true
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    config.after_initialize do
      if defined? FactoryGirl
        FactoryGirl.definition_file_paths << Junket::Engine.root.join('spec/factories')
      end
    end
  end
end
