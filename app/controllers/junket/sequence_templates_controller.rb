require_dependency 'junket/application_controller'

class Junket::SequenceTemplatesController < Junket::ApplicationController
  load_and_authorize_resource

  # All templates I can see
  def index
    respond_with(@sequence_templates)
  end

  # Templates I can edit
  def mine
    respond_with(@sequence_templates.where(access_level: :private))
  end

  # Templates I can't edit
  def public
    respond_with(@sequence_templates.where(access_level: :public))
  end

  # A single template
  def show
    respond_with(@sequence_template)
  end

  # Update a template
  def update
    @sequence_template.update_attributes(sequence_template_params)
    respond_with(@sequence_template)
  end

  # Create a template
  def create
    if @sequence_template.save
      respond_with(@sequence_template)
    else
      respond_with(@sequence.errors, status: :unprocessable_entity)
    end
  end

  def destroy
    @sequence_template.destroy
    respond_with(@sequence_template)
  end

  private

  def sequence_template_params
    # We allow :access_level, :owner_id and :owner_type as they're validated against ability.rb by CanCan
    params.require(:sequence_template).permit(:id, :name, :send_email, :email_subject, :email_body, :send_sms, :sms_body,
                                              :access_level, :owner_id, :owner_type)
  end
end
