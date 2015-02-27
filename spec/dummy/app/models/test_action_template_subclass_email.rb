class TestActionTemplateSubclassEmail < Junket::ActionTemplate
  def create_action_for(struct)
    super(struct)
  end

  def send_email?
    true
  end

  def send_sms?
    false
  end
end
