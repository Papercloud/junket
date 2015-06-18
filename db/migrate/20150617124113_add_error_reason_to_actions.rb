class AddErrorReasonToActions < ActiveRecord::Migration
  def change
    # You need postgres for this to work obviously
    add_column :junket_actions, :error_reason, :string, array: true
  end
end
