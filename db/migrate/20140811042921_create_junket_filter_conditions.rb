class CreateJunketFilterConditions < ActiveRecord::Migration
  def change
    create_table :junket_filter_conditions do |t|
      t.references :filter, index: true
      t.references :action_template, index: true
      t.string :value

      t.timestamps
    end
  end
end
