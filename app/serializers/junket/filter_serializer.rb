module Junket
  class FilterSerializer < ActiveModel::Serializer
    attributes :id, :name, :value_type
  end
end