class TestActionTemplateSubclassEmail < Junket::ActionTemplate
  validates :email_subject, presence: true
  validates :email_subject, length: { maximum: 78 }
  validates :email_body, presence: true
  validates :sms_body, presence: true
  validates :sms_body, length: { maximum: 160 }

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
