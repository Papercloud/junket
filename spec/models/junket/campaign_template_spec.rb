RSpec.describe Junket::CampaignTemplate do
  it { should validate_presence_of :name }
  it { should_not validate_presence_of :campaign_name }

  describe 'when set to send email' do
    subject do
      build(:junket_campaign_template, send_email: true)
    end

    it { should validate_presence_of :email_subject }
    it { should validate_presence_of :email_body }

  end

  describe 'when set to send sms' do
    subject do
      build(:junket_campaign_template, send_sms: true)
    end

    it { should validate_presence_of :sms_body }

  end

  describe 'when set to send neither sms nor email' do
    subject do
      build(:junket_campaign_template, send_sms: false, send_email: false)
    end

    it { should validate_acceptance_of :send_sms }
    it { should validate_acceptance_of :send_email }
  end

end
