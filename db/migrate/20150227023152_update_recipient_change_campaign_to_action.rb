class UpdateRecipientChangeCampaignToAction < ActiveRecord::Migration
  def up
    rename_column :junket_recipients, :campaign_id, :action_id
  end
  def down
    rename_column :junket_recipients, :action_id, :campaign_id
  end
end
