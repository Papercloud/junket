Junket::Engine.routes.draw do

  # Templates for campaigns. Email subject, email body with placeholders, SMS body.
  resources :campaign_templates do

    # Templates the user can edit
    get :mine, on: :collection

    # Templates the user can only read
    get :public, on: :collection
  end

end
