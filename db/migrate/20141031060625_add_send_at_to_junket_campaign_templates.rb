class AddSendAtToJunketCampaignTemplates < ActiveRecord::Migration
  def change
    add_column :junket_campaign_templates, :send_at, :datetime
  end
end
