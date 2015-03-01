ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'shoulda'
require 'factory_girl'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'
require 'database_cleaner'
require 'json_spec'
require 'pry'
require 'sidekiq'

require 'junket'

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include JsonSpec::Helpers

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.include(Module.new do
    def self.included(base)
      base.routes { Junket::Engine.routes }
    end
  end, type: :controller)

  def stub_current_user
    before :each do
      allow_any_instance_of(Junket::ApplicationController).to receive(:current_user).and_return(current_user)
    end
  end

  def current_user
    OpenStruct.new(id: 1)
  end
end
