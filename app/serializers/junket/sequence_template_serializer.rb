class Junket::SequenceTemplateSerializer < ActiveModel::Serializer
  attributes\
    :id,
    :name,
    :access_level

  has_many :action_templates, embed: :ids, include: false
end
