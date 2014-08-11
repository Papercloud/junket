class Junket::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_migrations
    rake 'junket:install:migrations'
  end

  def copy_initializer
    template 'initializer.rb', 'config/initializers/junket.rb'
  end
end
