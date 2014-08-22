resource 'Campaign Templates' do

  stub_current_user

  before :each do
    @public_template = create(:junket_campaign_template, access_level: 'public')
    @my_template = create(:junket_campaign_template, access_level: 'private', owner_id: 1, owner_type: 'OpenStruct')
  end

  def expect_attributes
    [:id, :name, :send_sms, :send_email, :email_subject, :email_body, :sms_body].each do |attribute|
      expect(response_body).to have_json_path("campaign_templates/0/#{attribute}")
    end
  end

  response_field :name, 'New Feature' # , :scope => :the_scope

  get '/junket/campaign_templates' do
    example 'List all templates that the user can read' do
      do_request
      expect(status).to eq 200
      expect_attributes
    end
  end

  get '/junket/campaign_templates/mine' do
    example 'List templates that the user can edit' do
      do_request
      expect(status).to eq 200
      expect_attributes
    end
  end

  get '/junket/campaign_templates/public' do
    example 'List templates that the user can only read' do
      do_request
      expect(status).to eq 200
      expect_attributes
    end
  end

  get '/junket/campaign_templates/:id' do
    example 'Get a single template' do
      do_request(id: Junket::CampaignTemplate.first.id)
      expect(status).to eq 200
      expect(response_body).to have_json_path('campaign_template/id')
    end
  end

  put '/junket/campaign_templates/:id' do
    example 'Update an existing template' do
      new_subject = 'My New Subject'
      do_request(id: @my_template.id, campaign_template: { email_subject: new_subject })

      expect(status).to eq 204
      expect(response_body).to have_json_value('campaign_template/email_subject', new_subject)
    end
  end

  post '/junket/campaign_templates' do
    example 'Create a template' do
      do_request(campaign_template: attributes_for(:junket_campaign_template, access_level: 'private', owner_id: 1, owner_type: 'OpenStruct'))

      expect(status).to eq 201
      expect(response_body).to have_json_path('campaign_template/id')
    end
  end
end