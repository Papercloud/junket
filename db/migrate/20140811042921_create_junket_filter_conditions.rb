class CreateJunketFilterConditions < ActiveRecord::Migration
  def change
    create_table :junket_filter_conditions do |t|
      t.references :filter, index: true
      t.string :value

      t.timestamps
    end

    create_join_table :junket_campaign_templates, :junket_filter_conditions
  end
end
