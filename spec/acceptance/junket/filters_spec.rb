resource 'Filters' do

  before :each do
    @filter = create(:junket_filter)
  end

  get '/junket/filters' do
    example 'List all available filters' do
      do_request

      expect(status).to eq 200
      expect(response_body).to have_json_size(1).at_path('filters')
    end
  end

end