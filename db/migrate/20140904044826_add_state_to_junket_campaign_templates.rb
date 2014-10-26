class AddStateToJunketCampaignTemplates < ActiveRecord::Migration
  def change
    add_column :junket_campaign_templates, :state, :string
  end
end
