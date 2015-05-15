class AddDefaultBodyToTemplate < ActiveRecord::Migration
  def up
    add_column :junket_sequence_templates, :default_body, :text, null: true
  end

  def down
    remove_column :junket_sequence_templates, :default_body
  end
end
