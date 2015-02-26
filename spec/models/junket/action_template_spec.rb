# == Schema Information
#
# Table name: junket_action_templates
#
#  id                   :integer          not null, primary key
#  name                 :string(255)
#  campaign_name        :string(255)
#  email_subject        :string(255)
#  email_body           :text
#  sms_body             :text
#  created_at           :datetime
#  updated_at           :datetime
#  type                 :string(255)
#  sequence_template_id :integer
#  run_after_duration   :integer          default(0), not null
#  position             :integer          default(0), not null
#

RSpec.describe Junket::ActionTemplate do



  describe 'when set to send email' do
    subject do
      build(:junket_action_template, send_email: true)
    end

    it { should validate_presence_of :email_subject }
    it { should validate_presence_of :email_body }
    it { should validate_presence_of :name }

    it 'adds a validation error for invalid email subject Liquid syntax' do
      subject.email_subject = 'Hi {{ name }'
      subject.valid?
      expect(subject.errors[:email_subject]).to eq ["Liquid syntax error: Variable '{{ name }' was not properly terminated with regexp: /\\}\\}/"]
    end

    it 'adds a validation error for invalid email body Liquid syntax' do
      subject.email_body = 'Hi {{ name }'
      subject.valid?
      expect(subject.errors[:email_body]).to eq ["Liquid syntax error: Variable '{{ name }' was not properly terminated with regexp: /\\}\\}/"]
    end
  end

  describe 'when set to send sms' do
    subject do
      build(:junket_action_template, send_sms: true)
    end

    it { should validate_presence_of :sms_body }
    it { should validate_presence_of :name }

    it 'adds a validation error for invalid sms body Liquid syntax' do
      subject.sms_body = 'Hi {{ name }'
      subject.valid?
      expect(subject.errors[:sms_body]).to eq ["Liquid syntax error: Variable '{{ name }' was not properly terminated with regexp: /\\}\\}/"]
    end
  end

  describe 'when set to send neither sms nor email' do
    subject do
      template = build(:junket_action_template)
      allow(template).to receive(:send_sms?) { false }
      allow(template).to receive(:send_email?) { false }
      template
    end

    it { should validate_acceptance_of :send_sms? }
    it { should validate_acceptance_of :send_email? }
    it { should validate_presence_of :name }
  end

  describe 'created action_template' do
    subject do
      create(:junket_action_template)
    end

    it 'will make a recall template' do
      structure = OpenStruct.new(id: '5', name: 'Blah', email: 'porridge@hotdoc.com')
      subject.create_action_for(structure)

      # has run_datetime
      expect(Junket::Action.first.run_datetime).to_not eq(nil)
      # same seq temp
      expect(Junket::Action.first.sequence_template).to eq(subject)
      # has set the object
      expect(Junket::Action.first.object.id).to eq('5')
      # subclass tells you if its an email
      expect(Junket::Action.first.send_email?).to eq(true)
    end
  end

end
