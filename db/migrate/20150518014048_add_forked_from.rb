class AddForkedFrom < ActiveRecord::Migration
  def up
    add_column :junket_sequence_templates, :forked_from_id, :integer, null: true, index: true
  end

  def down
    remove_column :junket_sequence_templates, :forked_from_id
  end
end
