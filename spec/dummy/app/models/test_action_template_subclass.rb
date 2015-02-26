class TestActionTemplateSubclass < Junket::ActionTemplate
  def create_action_for(struct)
    super(struct)
  end

  def send_email?
    true
  end

  def send_sms?
    true
  end
end
