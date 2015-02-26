resource 'Action Templates' do

  stub_current_user

  let(:sequence_template) do
    create(:junket_sequence_template, access_level: 'private', owner_id: 1, owner_type: 'OpenStruct')
  end

  let(:action_template_id) do
    sequence_template.action_templates.first.id
  end

  def expect_attributes
    [:id, :name, :email_body, :type, :sequence_template_id, :position, :run_after_duration].each do |attribute|
      expect(response_body).to have_json_path("action_templates/0/#{attribute}")
    end
  end

  # This is for api documentation generation
  response_field :name, 'Name of the template'

  get '/junket/action_templates?sequence_template_id=:id' do
    example 'List all templates' do
      sequence_template
      do_request id: sequence_template.id
      expect(status).to eq 200
      expect_attributes
    end
  end

  get '/junket/action_templates?sequence_template_id=:id' do
    example 'List all templates' do
      do_request id: sequence_template.id
      expect(status).to eq 200
      expect_attributes
    end
  end

  get '/junket/action_templates?sequence_template_id=:id' do
    example 'Dont show from other sequence templates' do
      other_seq = create(:junket_sequence_template, access_level: 'private', owner_id: 1, owner_type: 'OpenStruct')
      do_request id: sequence_template.id
      expect(response_body).to have_json_path('action_templates/0/id/')
      expect(parse_json(response_body)['action_templates'].map { |t| t['id'] }).to_not include(other_seq.action_templates.first)
    end
  end

  get '/junket/action_templates/:id' do
    example 'Get a single template' do
      do_request(id: action_template_id)
      expect(status).to eq 200
      expect(response_body).to have_json_path('action_template/id')
      expect(parse_json(response_body)['action_template']['id']).to eq(action_template_id)
    end
  end

  put '/junket/action_templates/:id' do
    example 'Update an existing template' do
      new_subject = 'My New Subject'
      do_request(id: action_template_id, action_template: { email_subject: new_subject })

      expect(status).to eq 200
      expect(parse_json(response_body)['action_template']['email_subject']).to eq 'My New Subject'
    end
  end
  #
  post '/junket/action_templates' do
    example 'Create a template' do
      do_request(action_template: attributes_for(:junket_action_template, sequence_template_id: sequence_template.id))
      expect(status).to eq 201
      expect(response_body).to have_json_path('action_template/id')
    end
  end
end
