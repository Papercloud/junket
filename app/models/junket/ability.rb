class Junket::Ability
  include CanCan::Ability

  def initialize(user)
    private_template_conditions = {
      owner_id: user.id, owner_type: user.class.name
    }

    public_template_conditions = {
      access_level: 'public'
    }

    can :manage, Junket::CampaignTemplate, private_template_conditions
    can [:index, :show, :public], Junket::CampaignTemplate, public_template_conditions

    can :manage, Junket::FilterCondition, campaign_template: private_template_conditions
    can [:index, :show], Junket::FilterCondition, campaign_template: public_template_conditions
  end
end
