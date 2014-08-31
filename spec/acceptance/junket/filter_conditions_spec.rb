resource 'Filter Conditions' do

  stub_current_user

  before :each do
    @template = create(:junket_campaign_template, access_level: 'private', owner_id: current_user.id, owner_type: current_user.class.name)
    @filter_condition = create(:junket_filter_condition, campaign_template: @template)
  end

  get '/junket/campaign_templates/:campaign_template_id/filter_conditions' do
    example 'List all filter conditions associated with a template' do
      do_request campaign_template_id: @template.id

      expect(status).to eq 200
      expect(response_body).to have_json_size(1).at_path('filter_conditions')
    end
  end

  get '/junket/campaign_templates/:campaign_template_id/filter_conditions/:id' do
    example 'Get a single filter condition' do
      do_request campaign_template_id: @template.id, id: @filter_condition.id

      expect(status).to eq 200
      expect(response_body).to have_json_path('filter_condition/id')
    end
  end

  post '/junket/campaign_templates/:campaign_template_id/filter_conditions' do
    example 'Create a new filter condition' do
      do_request campaign_template_id: @template.id, filter_condition: attributes_for(:junket_filter_condition).merge(filter_id: create(:junket_filter).id, campaign_template_id: @template.id)

      expect(status).to eq 201
      expect(response_body).to have_json_path('filter_condition/id')
    end
  end

  put '/junket/campaign_templates/:campaign_template_id/filter_conditions/:id' do
    example 'Update a filter condition' do
      do_request campaign_template_id: @template.id, id: @filter_condition.id, filter_condition: { value: 'new value' }

      expect(status).to eq 200
      expect(response_body).to have_json_path('filter_condition/id')
    end
  end

  delete '/junket/campaign_templates/:campaign_template_id/filter_conditions/:id' do
    example 'Create a new filter condition' do
      do_request campaign_template_id: @template.id, id: @filter_condition.id

      expect(status).to eq 204
    end
  end

end