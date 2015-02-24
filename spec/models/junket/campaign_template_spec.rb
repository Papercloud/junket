# == Schema Information
#
# Table name: junket_campaign_templates
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  campaign_name :string(255)
#  email_subject :string(255)
#  email_body    :text
#  sms_body      :text
#  send_email    :boolean          default(TRUE), not null
#  send_sms      :boolean          default(TRUE), not null
#  access_level  :string(255)      default("private")
#  owner_id      :integer
#  owner_type    :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  type          :string(255)
#  state         :string(255)
#  send_at       :datetime
#

RSpec.describe Junket::CampaignTemplate do
  it { should validate_presence_of :name }
  it { should_not validate_presence_of :campaign_name }

  describe 'when set to send email' do
    subject do
      build(:junket_campaign_template, send_email: true)
    end

    it { should validate_presence_of :email_subject }
    it { should validate_presence_of :email_body }

    it 'adds a validation error for invalid email subject Liquid syntax' do
      subject.email_subject = 'Hi {{ name }'
      subject.valid?
      expect(subject.errors[:email_subject]).to eq ["Variable '{{ name }' was not properly terminated with regexp: /\\}\\}/ "]
    end

    it 'adds a validation error for invalid email body Liquid syntax' do
      subject.email_body = 'Hi {{ name }'
      subject.valid?
      expect(subject.errors[:email_body]).to eq ["Variable '{{ name }' was not properly terminated with regexp: /\\}\\}/ "]
    end
  end

  describe 'when set to send sms' do
    subject do
      build(:junket_campaign_template, send_sms: true)
    end

    it { should validate_presence_of :sms_body }

    it 'adds a validation error for invalid sms body Liquid syntax' do
      subject.sms_body = 'Hi {{ name }'
      subject.valid?
      expect(subject.errors[:sms_body]).to eq ["Variable '{{ name }' was not properly terminated with regexp: /\\}\\}/ "]
    end
  end

  describe 'when set to send neither sms nor email' do
    subject do
      build(:junket_campaign_template, send_sms: false, send_email: false)
    end

    it { should validate_acceptance_of :send_sms }
    it { should validate_acceptance_of :send_email }
  end

end
