resource 'Campaign Templates' do

  stub_current_user

  get '/junket/campaign_templates' do
    example 'Listing templates' do
      do_request

      expect(status).to eq 200
    end
  end
end