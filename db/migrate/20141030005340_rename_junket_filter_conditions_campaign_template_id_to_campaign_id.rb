class RenameJunketFilterConditionsCampaignTemplateIdToCampaignId < ActiveRecord::Migration
  def change
    rename_column :junket_filter_conditions, :action_template_id, :campaign_id
  end
end
