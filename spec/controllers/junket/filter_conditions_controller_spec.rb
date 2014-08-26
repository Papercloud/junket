# Note this controller is also tested by spec/acceptance/junket/filter_conditions_spec.rb

describe Junket::FilterConditionsController, type: :controller do

  routes { Junket::Engine.routes }

  stub_current_user

  describe 'PUT /junket/campaign_templates/:campaign_template_id/filter_conditions/:id' do

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

end