class TestActionTemplateSubclassSmsWithErrorLogs < TestActionTemplateSubclassSms
  # stub
  def create_next_action(_)
  end

  def sms_errors(_action)
    [:asdf, :fdsa]
  end
end
