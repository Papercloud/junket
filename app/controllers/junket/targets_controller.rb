require_dependency 'junket/application_controller'

class Junket::TargetsController < Junket::ApplicationController
  def index
    @template = Junket::CampaignTemplate.first
    respond_with(@template.targets)
  end

  def count
    @template = Junket::CampaignTemplate.first
    respond_with(@template.targets.count)
  end
end