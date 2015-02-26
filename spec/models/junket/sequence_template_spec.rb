# == Schema Information
#
# Table name: junket_sequence_templates
#
#  id           :integer          not null, primary key
#  name         :string(255)      not null
#  owner_id     :integer
#  owner_type   :string(255)
#  access_level :string(255)      default("private"), not null
#  created_at   :datetime
#  updated_at   :datetime
#
RSpec.describe Junket::SequenceTemplate do
  describe 'standard' do

    subject do
      create(:junket_sequence_template)
    end

    it 'create first action on reacll' do
      structure = OpenStruct.new(id: 'piss', name: 'shit', email: 'porridge')
      subject.action_templates.first.create_action_for(structure)

      # has send_at
      expect(Action.first.send_at).to_not eq(nil)
      # same seq temp
      expect(Action.first.sequence_template).to eq(subject)
      # has set the object
      expect(Action.first.object.id).to eq('piss')
      # subclass tells you if its an email
      expect(Action.first.send_email?).to eq(true)
    end

    it 'factory works' do
      expect(subject).to be_persisted
      expect(subject.action_templates.empty?).to eq(false)
    end
  end
end
