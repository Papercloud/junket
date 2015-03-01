class AddSequenceTables < ActiveRecord::Migration
  def up
    create_table :junket_sequence_templates do |t|
      t.string :name, null: false
      t.references :owner, polymorphic: true, index: true
      t.string :access_level, null: false, default: 'private', index: true
      t.timestamps
    end

    create_table :junket_actions do |t|
      t.belongs_to :action_template, null: false, index: true
      t.references :object, null: false, polymorphic: true, index: true
      t.string :state, null: false
      t.datetime :run_datetime, null: false
      t.timestamps
    end

    # These columns are now on the sequence template, not campaign template
    remove_column :junket_campaign_templates, :access_level
    remove_column :junket_campaign_templates, :owner_id
    remove_column :junket_campaign_templates, :owner_type
    remove_column :junket_campaign_templates, :send_at
    remove_column :junket_campaign_templates, :send_email
    remove_column :junket_campaign_templates, :send_sms
    remove_column :junket_campaign_templates, :state

    add_column :junket_campaign_templates, :run_after_duration, :integer, default: 0, null: false
    add_column :junket_campaign_templates, :position, :integer, default: 0, null: false

    change_table :junket_campaign_templates do |t|
      t.belongs_to :sequence_template, index: true
    end

    rename_table :junket_campaign_templates, :junket_action_templates
  end

  def down
    [:junket_actions, :junket_sequence_templates].each do |table|
      drop_table table
    end

    remove_column :junket_action_templates, :junket_sequence_template_id
    remove_column :junket_action_templates, :run_after_duration
    remove_column :junket_action_templates, :position

    add_column :junket_action_templates, :access_level, :string, default: :private, index: true
    add_column :junket_action_templates, :send_at, :datetime
    add_column :junket_action_templates, :send_email, :boolean, default: true, null: false
    add_column :junket_action_templates, :send_sms, :boolean, default: true, null: false
    add_column :junket_action_templates, :state, :string

    change_table :junket_action_templates do |t|
      t.references :owner, polymorphic: true, index: true
    end

    rename_table :junket_action_templates, :junket_campaign_templates
  end
end
