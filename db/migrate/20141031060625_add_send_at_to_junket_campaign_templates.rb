class AddSendAtToJunketCampaignTemplates < ActiveRecord::Migration
  def change
    add_column :junket_action_templates, :send_at, :datetime
  end
end
