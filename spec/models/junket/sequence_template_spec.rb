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

    it 'factory works' do
      expect(subject).to be_persisted
      expect(subject.action_templates.empty?).to eq(false)
    end
  end
end
