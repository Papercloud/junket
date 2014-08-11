class AddValueTypeToJunketFilters < ActiveRecord::Migration
  def change
    add_column :junket_filters, :value_type, :string
  end
end
