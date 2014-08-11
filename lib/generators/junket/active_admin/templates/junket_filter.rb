ActiveAdmin.register Junket::Filter, as: 'Filter' do

  menu label: 'Filters', parent: 'Campaigns'

  permit_params :name, :term, :value_type

  filter :name

  index do
    column :name
    column :term
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name, hint: 'Name for this filter shown to users'
      f.input :term, hint: 'Ransack filter term, e.g. "name_eq"'
      f.input :value_type, as: :select, collection: [:boolean, :string, :integer], include_blank: false
    end
    f.actions
  end

end
