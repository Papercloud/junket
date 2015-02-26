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
# RSpec.describe Junket::SequenceTemplate do
#   describe 'factory' do
#     subject do
#       create(:junket_sequence)
#     end
#
#     it 'after create it makes actions with send_at times and template ids' do
#
#       action_template_ids = subject.sequence_template.sequence_action_times.map(&:action_template_id)
#
#       expect(action_template_ids.count).to eq(2)
#       expect(subject.actions.count).to eq(2)
#       expect(subject.actions.map(&:send_at)).to_not include(nil)
#       expect(subject.actions.map(&:action_template_id)).to eq(action_template_ids), 'actions use same campaign templates'
#       expect(subject.actions.map(&:send_at)).to_not include(nil)
#     end
#
#   end
# end
