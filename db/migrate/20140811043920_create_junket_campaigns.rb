class CreateJunketCampaigns < ActiveRecord::Migration
  def change
    create_table :junket_campaigns do |t|
      t.string :name
      t.datetime :send_at
      t.integer :owner_id
      t.string :owner_type
      t.integer :campaign_template_id

      t.timestamps
    end
  end
end
