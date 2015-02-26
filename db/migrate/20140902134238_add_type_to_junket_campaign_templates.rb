class AddTypeToJunketCampaignTemplates < ActiveRecord::Migration
  def change
    add_column :junket_campaign_templates, :type, :string
  end
end
