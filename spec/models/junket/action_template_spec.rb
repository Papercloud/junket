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
      build(:junket_action_template_email)
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
      build(:junket_action_template_sms)
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
      template = build(:junket_action_template_none)
      # allow(template).to receive(:send_sms?) { false }
      # allow(template).to receive(:send_email?) { false }
      template
    end

    it { expect(subject.send_sms?).to eq(false) }
    it { expect(subject.send_email?).to eq(false) }
    it { should validate_presence_of :name }
  end

  describe 'created action_template' do
    subject do
      create(:junket_action_template_email)
    end

    it 'will make a recall template' do
      structure = OpenStruct.new(id: '5', name: 'Blah', email: 'porridge@hotdoc.com')
      subject.create_action_for(structure)

      #p Junket::Action.first.object

      # has run_datetime
      expect(Junket::Action.first.run_datetime).to_not eq(nil)
      # same seq temp
      expect(Junket::Action.first.action_template).to eq(subject)
      # has set the object
      # probably should test .object.id but OpenStruct doesnt like it
      expect(Junket::Action.first.object_id).to eq(5)
      # subclass of ActionTemplate tells you if its an email, not action
      # expect(Junket::Action.first.send_email?).to eq(true)
    end
  end

end
