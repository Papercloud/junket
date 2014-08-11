class Junket::Ability
  include CanCan::Ability

  def initialize(user)
    can :manage, Junket::CampaignTemplate, owner_id: user.id, owner_type: user.class.name
    can [:index, :show, :public], Junket::CampaignTemplate, access_level: 'public'
  end
end
