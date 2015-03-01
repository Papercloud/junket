resource 'Filter Conditions' do

  stub_current_user

  before :each do
    pending 'KG broke it'
    @template = create(:junket_action_template, access_level: 'private', owner_id: current_user.id, owner_type: current_user.class.name)
    @filter_condition = create(:junket_filter_condition, action_template: @template)
  end

  get '/junket/action_templates/:action_template_id/filter_conditions' do
    example 'List all filter conditions associated with a template' do
      pending 'kg: seems like we need to make filter_conditions nested into campaign templates to get this to pass'
      do_request action_template_id: @template.id

      expect(status).to eq 200
      expect(response_body).to have_json_size(1).at_path('filter_conditions')
    end
  end

  get '/junket/action_templates/:action_template_id/filter_conditions/:id' do
    example 'Get a single filter condition' do
      pending 'kg: seems like we need to make filter_conditions nested into campaign templates to get this to pass'
      do_request action_template_id: @template.id, id: @filter_condition.id

      expect(status).to eq 200
      expect(response_body).to have_json_path('filter_condition/id')
    end
  end

  post '/junket/action_templates/:action_template_id/filter_conditions' do
    example 'Create a new filter condition' do
      pending 'kg: seems like we need to make filter_conditions nested into campaign templates to get this to pass'
      do_request action_template_id: @template.id, filter_condition: attributes_for(:junket_filter_condition).merge(filter_id: create(:junket_filter).id, action_template_id: @template.id)

      expect(status).to eq 201
      expect(response_body).to have_json_path('filter_condition/id')
    end
  end

  put '/junket/action_templates/:action_template_id/filter_conditions/:id' do
    example 'Update a filter condition' do
      pending 'kg: seems like we need to make filter_conditions nested into campaign templates to get this to pass'
      do_request action_template_id: @template.id, id: @filter_condition.id, filter_condition: { value: 'new value' }

      expect(status).to eq 200
      expect(response_body).to have_json_path('filter_condition/id')
    end
  end

  delete '/junket/action_templates/:action_template_id/filter_conditions/:id' do
    example 'Create a new filter condition' do
      pending 'kg: seems like we need to make filter_conditions nested into campaign templates to get this to pass'
      do_request action_template_id: @template.id, id: @filter_condition.id

      expect(status).to eq 204
    end
  end

end
