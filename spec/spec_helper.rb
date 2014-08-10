ENV['RAILS_ENV'] = 'test'
require File.expand_path('../dummy/config/environment.rb',  __FILE__)

require 'rspec/rails'
require 'shoulda'
require 'factory_girl'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

require 'junket'

FactoryGirl.definition_file_paths = [File.expand_path('../factories', __FILE__)]
FactoryGirl.find_definitions

Rails.backtrace_cleaner.remove_silencers!

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods

  def stub_current_user
    before :each do
      allow_any_instance_of(Junket::ApplicationController).to receive(:current_user).and_return(OpenStruct.new)
    end
  end
end
