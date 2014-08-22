describe Junket::CampaignTemplatesController, type: :controller do

  routes { Junket::Engine.routes }

  stub_current_user

  def create_private_template(owner_id = 1)
    create(:junket_campaign_template, access_level: :private, owner_id: owner_id, owner_type: current_user.class.name)
  end

  def create_public_template
    create(:junket_campaign_template, access_level: :public, owner_id: 1, owner_type: 'AdminUser')
  end

  describe 'GET /junket/campaign_templates/mine' do

    it 'returns templates created by the logged in user' do
      create_private_template
      get :mine
      expect(response.body).to have_json_size(1).at_path('campaign_templates')
    end

    it 'does not return templates created by another user' do
      # Someone else's template
      create_private_template(2)

      get :mine
      expect(response.body).to have_json_size(0).at_path('campaign_templates')
    end

    it 'does not return templates created by admin for all users' do
      create_public_template
      get :mine
      expect(response.body).to have_json_size(0).at_path('campaign_templates')
    end

  end

  describe 'GET /junket/campaign_templates/public' do

    it 'returns templates created by admin for all users' do
      create_public_template
      get :public
      expect(response.body).to have_json_size(1).at_path('campaign_templates')
    end

    it 'does not return templates created by the user' do
      create_private_template
      get :public
      expect(response.body).to have_json_size(0).at_path('campaign_templates')
    end

  end

  describe 'GET /junket/campaign_templates' do

    it 'returns templates created by admin for all users' do
      create_public_template
      get :index
      expect(response.body).to have_json_size(1).at_path('campaign_templates')
    end

    it 'returns templates created by the logged in user' do
      create_private_template
      get :index
      expect(response.body).to have_json_size(1).at_path('campaign_templates')
    end

  end

  describe 'POST /junket/campaign_templates' do

    it 'cannot create a template with a disallowed access level' do
      post :create, campaign_template: attributes_for(:junket_campaign_template, access_level: :public, owner_id: 1, owner_type: 'AdminUser')
      expect(response.response_code).to eq 406
    end

  end

end