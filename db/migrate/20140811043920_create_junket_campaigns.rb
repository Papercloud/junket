class CreateJunketCampaigns < ActiveRecord::Migration
  def change
    create_table :junket_campaigns do |t|
      t.string :name
      t.datetime :send_at, index: true
      t.references :owner, polymorphic: true, index: true
      t.integer :campaign_template_id, index: true

      t.timestamps
    end
  end
end
