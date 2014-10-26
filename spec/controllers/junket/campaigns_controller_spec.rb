describe Junket::CampaignsController, type: :controller do

  stub_current_user

  describe 'POST /junket/campaigns' do

    it 'creates a template' do
      post :create, campaign: attributes_for(:junket_campaign)
      expect(response.response_code).to eq 201
    end

    it 'responds with the created object' do
      post :create, campaign: attributes_for(:junket_campaign)
      expect(response.body).to have_json_path('campaign/id')
    end

    it 'sets the owner of the created template to the current logged in user' do
      post :create, campaign: attributes_for(:junket_campaign)
      expect(Junket::Campaign.first.owner_id).to eq current_user.id
    end

  end

  describe 'PUT /junket/campaigns/:id/deliver' do

    it 'returns success' do
      campaign = create(:junket_campaign, owner_id: current_user.id, owner_type: current_user.class.name)
      put :deliver, id: campaign.id
      expect(response.response_code).to eq 200
    end

  end

end