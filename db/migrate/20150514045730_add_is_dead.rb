class AddIsDead < ActiveRecord::Migration
  def up
    add_column :junket_action_templates, :is_dead, :boolean, default: true, null: false
  end
end
