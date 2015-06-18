# == Schema Information
#
# Table name: junket_actions
#
#  id                 :integer          not null, primary key
#  action_template_id :integer          not null
#  object_id          :integer          not null
#  object_type        :string(255)      not null
#  state              :string(255)      not null
#  run_datetime       :datetime         not null
#  created_at         :datetime
#  updated_at         :datetime
#

FactoryGirl.define do

  factory :junket_action, class: 'Junket::Action' do
    run_datetime 10.minutes.from_now
    association :action_template, factory: :junket_action_template_sms
    state 'scheduled'

    before(:create) do |obj, _eval|
      obj.object_id = 1
      obj.object_type = 'OpenStruct'
    end
  end

end
