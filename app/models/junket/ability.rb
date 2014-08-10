class Junket::Ability
  include CanCan::Ability

  def initialize(_user)
    can :manage, Junket::CampaignTemplate
  end
end
