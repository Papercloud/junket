module Junket
  class FilterConditionSerializer < ActiveModel::Serializer
    attributes\
      :id,
      :value,
      :campaign_id,
      :action_template_id

    def action_template_id
      object.campaign_id
    end

    has_one :filter, embed: :ids, include: true
  end
end