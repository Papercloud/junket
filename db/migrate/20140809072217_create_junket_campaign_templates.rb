class CreateJunketCampaignTemplates < ActiveRecord::Migration
  def change
    create_table :junket_campaign_templates do |t|
      t.string :name
      t.string :campaign_name
      t.string :email_subject
      t.text :email_body
      t.text :sms_body
      t.boolean :send_email, default: true
      t.boolean :send_sms, default: true
      t.string :access_level, default: :private
      t.integer :owner_id
      t.string :owner_type

      t.timestamps
    end
  end
end
