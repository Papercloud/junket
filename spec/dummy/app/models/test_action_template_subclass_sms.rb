class TestActionTemplateSubclassSms < Junket::ActionTemplate
  def create_action_for(struct)
    super(struct)
  end

  def send_email?
    false
  end

  def send_sms?
    true
  end
end
