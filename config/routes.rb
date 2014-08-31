Junket::Engine.routes.draw do

  # Templates for campaigns. Email subject, email body with placeholders, SMS body.
  resources :campaign_templates do

    # Templates the user can edit
    get :mine, on: :collection

    # Templates the user can only read
    get :public, on: :collection

    resources :filter_conditions

    # Get users currently targeted by the template's filter conditions
    get :targets, on: :member
  end

  resources :filters, only: [:index]

  resources :filter_conditions

end
