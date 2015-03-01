ActiveAdmin.register Junket::CampaignTemplate, as: 'Template' do

  menu label: 'Templates', parent: 'Campaigns'

  filter :name
  filter :email_subject
  filter :send_sms
  filter :send_email
  filter :owner_email, as: :string, if: ->(_o) { params['scope'] == 'private' }

  scope :public, default: true
  scope :private

  index do
    column :name
    column :updated_at
    actions
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :campaign_name, hint: 'Used to set the name of a campaign created with this template'
      f.input :send_email, hint: 'Whether to send emails'
      f.input :email_subject
      f.input :email_body, as: :ckeditor
      f.input :send_sms, hint: 'Whether to send SMS'
      f.input :sms_body
    end
    f.actions
  end

  controller do
    def permitted_params
      params.permit(action_template: [:name, :campaign_name, :email_subject, :email_body, :sms_body, :send_email, :send_sms])
    end

    def resource_request_name
      :action_template
    end

    def create
      # If an admin creates a template, it should be public.
      build_resource.access_level = :public
      create!
    end
  end

end
