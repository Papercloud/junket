class AddIsDead < ActiveRecord::Migration
  def up
    add_column :junket_action_templates, :is_dead, :boolean, default: false, null: false
  end

  def down
    remove_column :junket_action_templates, :is_dead
  end
end
