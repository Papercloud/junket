Junket::Engine.routes.draw do

  resources :campaign_templates, defaults: { format: 'json' }

end
