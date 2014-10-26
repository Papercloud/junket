Junket::Engine.routes.draw do

  # Templates for campaigns. Email subject, email body with placeholders, SMS body.
  resources :campaign_templates do

    # Templates the user can edit
    get :mine, on: :collection

    # Templates the user can only read
    get :public, on: :collection

    # TODO: Do we really need this nested version?
    # resources :filter_conditions
  end

  resources :filters, only: [:index]

  resources :filter_conditions

  # Targets for a given campaign.
  get '/targets' => 'targets#index'
  get '/targets/count' => 'targets#count'

  # Campaigns
  # TODO: Include read/opened/reaches stats.
  resources :campaigns do

    # Send everything and transition to state 'sent'
    put :deliver, on: :member
  end

  # Recipients of a sent campaign. Includes read status and tracking.
  resources :recipients

  resource :webhooks, controller: 'webhooks', only: [:create, :show]

end
