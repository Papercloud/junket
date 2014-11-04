# Note this controller is also tested by spec/acceptance/junket/filter_conditions_spec.rb

describe Junket::FilterConditionsController, type: :controller do

  stub_current_user

  describe 'PUT /junket/filter_conditions/:id' do

    it 'does not allow editing a condition on a public template' do
      public_template = create(:junket_campaign_template, access_level: :public, owner_id: 1, owner_type: 'AdminUser')
      filter_condition = create(:junket_filter_condition, campaign_template: public_template)

      put :update, campaign_template_id: public_template.id, id: filter_condition.id, filter_condition: { value: 'new value' }
      expect(response.response_code).to eq 403
    end

    it "does not allow editing a condition on someone else's private template" do
      private_template = create(:junket_campaign_template, access_level: :private, owner_id: 2, owner_type: current_user.class.name)
      filter_condition = create(:junket_filter_condition, campaign_template: private_template)

      put :update, campaign_template_id: private_template.id, id: filter_condition.id, filter_condition: { value: 'new value' }
      expect(response.response_code).to eq 403
    end

  end

  describe 'POST /junket/filter_conditions' do

    let(:filter) { create(:junket_filter) }

    it 'creates a filter condition on a campaign owned by the current user' do
      campaign = create(:junket_campaign, access_level: :private, owner_id: current_user.id, owner_type: current_user.class.name)
      post :create, filter_condition: { campaign_id: campaign.id, value: true, filter_id: filter.id }
      expect(response.response_code).to eq 201
    end

    it 'does not create a filter condition on a campaign owned by another user' do
      campaign = create(:junket_campaign, access_level: :private, owner_id: 2, owner_type: current_user.class.name)
      post :create, filter_condition: { campaign_id: campaign.id, value: true, filter_id: filter.id }
      expect(response.response_code).to eq 403
    end

  end
end