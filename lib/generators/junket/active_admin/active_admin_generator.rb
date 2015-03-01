class Junket::ActiveAdminGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def copy_resources
    template 'junket_action_template.rb', 'app/admin/junket_action_template.rb'
    template 'junket_filter.rb', 'app/admin/junket_filter.rb'
  end
end
