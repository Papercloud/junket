resource 'Campaign Templates' do

  stub_current_user

  before :each do
    create(:junket_campaign_template)
  end

  def expect_attributes
    [:id, :send_sms, :send_email, :email_subject, :email_body, :sms_body].each do |attribute|
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

  get '/junket/campaign_templates/example' do
    example 'List templates that the user can only read' do
      do_request
      expect(status).to eq 200
      expect_attributes
    end
  end
end