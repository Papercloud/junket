class Junket::SequenceTemplateSerializer < ActiveModel::Serializer
  attributes\
    :id,
    :name,
    :access_level

  has_many :sequence_action_times, embed: :ids, include: false
end
