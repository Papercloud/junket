require_dependency 'junket/application_controller'

class Junket::SequenceTemplatesController < Junket::ApplicationController
  load_and_authorize_resource

  # All templates I can see
  def index
    respond @sequence_templates
  end

  # Templates I can edit
  def mine
    respond @sequence_templates.where(access_level: :private)
  end

  # Templates I can't edit
  def public
    respond @sequence_templates.where(access_level: :public)
  end

  # A single template
  def show
    respond @sequence_template
  end

  # Update a template
  def update
    if @sequence_template.save @sequence_template.update_attributes(sequence_template_params)
      respond(@sequence_template)
    else
      respond_with(@sequence_template.errors, status: :unprocessable_entity)
    end
  end

  # Create a template
  def create
    if @sequence_template.save
      respond @sequence_template
    else
      respond_with(@sequence_template.errors, status: :unprocessable_entity)
    end
  end

  def destroy
    @sequence_template.destroy
    respond @sequence_template
  end

  private

  def respond(sequence_templates)
    if sequence_templates.is_a? ActiveRecord::Relation
      respond_with(sequence_templates, each_serializer: Junket::SequenceTemplateSerializer, root: :sequence_templates)
    else
      respond_with(sequence_templates, serializer: Junket::SequenceTemplateSerializer, root: :sequence_template)
    end
  end

  def sequence_template_params
    # We allow :access_level, :owner_id and :owner_type as they're validated against ability.rb by CanCan
    params.require(:sequence_template).permit(:id, :name, :access_level, :owner_id, :owner_type)
  end
end
