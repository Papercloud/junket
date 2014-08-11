class CreateJunketFilters < ActiveRecord::Migration
  def change
    create_table :junket_filters do |t|
      t.string :name
      t.string :term

      t.timestamps
    end
  end
end
