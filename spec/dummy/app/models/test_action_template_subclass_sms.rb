class TestActionTemplateSubclassSms < Junket::ActionTemplate
  validates :sms_body, presence: true
  validates :sms_body, length: { maximum: 160 }

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
