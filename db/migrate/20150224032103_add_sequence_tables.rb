class AddSequenceTables < ActiveRecord::Migration
  def up
    create_table :junket_sequence_templates do |t|
      t.string :name, null: false
      t.references :owner, polymorphic: true, index: true
      t.string :access_level, null: false, default: 'private', index: true
      t.timestamps
    end

    # These columns are now on the sequence template, not campaign template
    remove_column :junket_campaign_templates, :access_level
    remove_column :junket_campaign_templates, :owner_id
    remove_column :junket_campaign_templates, :owner_type
    # add_column :junket_campaign_templates, :junket_sequence_template_id, :integer, null: false, index: true

    create_table :junket_sequence_action_times do |t|
      t.integer :duration, null: false
      t.integer :position, null: false, default: 0
      t.belongs_to :sequence_template, null: false
      t.references :campaign_template, null: false, polymorphic: true
      t.timestamps
    end
    add_index :junket_sequence_action_times, [:sequence_template_id, :position], unique: true, name: 'index_seq_action_seq_template_id_position'

    create_table :junket_sequences do |t|
      # will be a recall in hotdocs case
      t.references :object, null: false, polymorphic: true, index: true
      t.belongs_to :sequence_template, null: false, index: true
      t.timestamps
    end

    create_table :junket_actions do |t|
      t.belongs_to :sequence, null: false, index: true
      t.belongs_to :campaign_template, null: false
      t.string :state, null: false
      t.timestamps
    end
  end

  def down
    [:junket_sequence_action_times, :junket_sequences, :junket_actions, :junket_sequence_templates].each do |table|
      drop_table table
    end
  end
end
