class CreateTemplateFilterConditionsJoinTable < ActiveRecord::Migration
  def change
    create_table :junket_campaign_templates_filter_conditions, id: false do |t|
      t.references :campaign_template
      t.references :filter_condition
      t.index :campaign_template_id, name: 'index_junket_campaign_templates_filter_conditions_template_id'
      t.index :filter_condition_id, name: 'index_junket_campaign_templates_filter_conditions_filter_id'
    end
  end
end
