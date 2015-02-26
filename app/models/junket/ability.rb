class Junket::Ability
  include CanCan::Ability

  def initialize(user)
    private_template_conditions = {
      owner_id: user.id, owner_type: user.class.name
    }

    public_template_conditions = {
      access_level: 'public'
    }

    can :manage, Junket::ActionTemplate, sequence_template: private_template_conditions
    can [:index, :show, :public], Junket::ActionTemplate, sequence_template: public_template_conditions
    can [:create], Junket::ActionTemplate

    can :manage, Junket::FilterCondition, campaign: private_template_conditions
    can [:index, :show], Junket::FilterCondition, sequence_template: public_template_conditions

    can :manage, Junket::SequenceTemplate, private_template_conditions
    # can still see the public templates
    can [:index, :show, :public], Junket::SequenceTemplate, public_template_conditions
  end
end
