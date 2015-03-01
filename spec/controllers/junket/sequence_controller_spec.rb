# describe Junket::SequencesController, type: :controller do
#
#   stub_current_user
#
#   let(:sequence_template) do
#     create(:junket_sequence_template)
#   end
#
#   let(:sequence) do
#     create(:junket_sequence, sequence_template: sequence_template, owner_id: current_user.id, owner_type: 'OpenStruct')
#   end
#
#   let(:not_my_sequence) do
#     create(:junket_sequence, sequence_template: sequence_template, owner_id: 1, owner_type: 'SomeClassThatIsntAUser')
#   end
#
#   let(:object) do
#     User.create(email: 'kg@a.com')
#   end
#
#   describe 'GET /junket/sequences' do
#     it 'shows only my sequences' do
#       sequence
#       not_my_sequence
#       another_sequence_i_own = create(:junket_sequence, sequence_template: sequence_template, owner_id: current_user.id, owner_type: 'OpenStruct')
#
#       get :index
#       expect(response.response_code).to eq 200
#       response_ids = parse_json(response.body)['sequences'].map { |seq| seq['id'] }
#       expect(response_ids).to include(sequence.id)
#       expect(response_ids).to include(another_sequence_i_own.id)
#       expect(response_ids).to_not include(not_my_sequence.id)
#     end
#   end
#
#   describe 'GET /junket/sequence/:id' do
#     it 'shows my sequence' do
#       get :show, id: sequence.id
#       expect(response.response_code).to eq 200
#       expect(response.body).to have_json_path('sequence/id')
#     end
#
#     it 'doesnt show other peoples sequences' do
#       get :show, id: not_my_sequence.id
#       expect(response.response_code).to eq 403
#     end
#   end
#
#   describe 'POST /junket/sequence' do
#     it 'cant create a sequence with a sequence_template_id that isnt mine and isnt public' do
#       template_id = create(:junket_sequence_template, owner_id: 1, owner_type: 'NotMyClass').id
#       post :create, sequence: { sequence_template_id: template_id, object_id: object.id, object_type: 'User' }
#       expect(response.response_code).to eq 422
#     end
#
#     it 'can create a sequence with a sequence_template_id that is public' do
#       template_id = create(:junket_sequence_template, access_level: 'public').id
#
#       post :create, sequence: { sequence_template_id: template_id, object_id: object.id, object_type: 'User' }
#       expect(response.response_code).to eq 201
#     end
#
#     it '422 without object' do
#       post :create, sequence: { sequence_template_id: sequence_template.id }
#       expect(response.response_code).to eq 422
#     end
#
#     it 'creates a sequence' do
#       post :create, sequence: { sequence_template_id: sequence_template.id, object_id: object.id, object_type: 'User' }
#
#       expect(response.response_code).to eq 201
#       expect(response.body).to have_json_path('sequence/id')
#       expect(Junket::Sequence.first.object_id).to eq object.id
#     end
#
#   end
#
# end
