require 'sidekiq/testing'

RSpec.describe Junket::Action do

  before :each do
  end

  let(:subject_without_error_method) do
    create(:junket_action)
  end

  let(:subject) do
    create(:junket_action, action_template: create(:junket_action_template_sms_with_error_logs))
  end

  it 'makes errors on action' do
    subject.become_error!
    subject.reload

    expect(subject.error?).to eq(true)
    expect(subject.error_reason).to eq(%w(asdf fdsa))
  end

  it 'makes no errors on action' do
    subject_without_error_method.become_error!

    expect(subject_without_error_method.error?).to eq(true)
    expect(subject_without_error_method.error_reason).to eq(nil)
  end

end
