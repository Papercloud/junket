class AddTypeToJunketCampaignTemplates < ActiveRecord::Migration
  def change
    add_column :junket_action_templates, :type, :string
  end
end
