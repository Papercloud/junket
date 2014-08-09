module Junket
  class Engine < ::Rails::Engine
    isolate_namespace Junket

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
