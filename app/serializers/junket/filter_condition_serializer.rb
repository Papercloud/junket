module Junket
  class FilterConditionSerializer < ActiveModel::Serializer
    attributes :id, :value
    has_one :filter, embed: :ids, include: true
    has_one :campaign_template, embed: :ids, include: false
  end
end