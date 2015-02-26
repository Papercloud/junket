class AddStateToJunketCampaignTemplates < ActiveRecord::Migration
  def change
    add_column :junket_action_templates, :state, :string
  end
end
