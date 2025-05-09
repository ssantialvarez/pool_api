require 'swagger_helper'

RSpec.describe 'api/players', type: :request do
  path '/players' do
    post 'Creates new player.' do
      tags 'Players'
      consumes 'application/json'
      security [ bearer: [] ]
      parameter name: 'new_player', in: :body, schema: { '$ref' => '#/components/schemas/new_player' }
      request_body_example value: { name: "John", auth0_id: 'auth0|432212', ranking: 1, profile_picture_url: 'https://pool-app-storage.s3.us-east-2.amazonaws.com/foto_de_perfil.jpg' }, name: 'basic', summary: 'Request example description'

      response '201', 'Player created successfully.' do
        schema '$ref' => '#/components/schemas/player'
        let(:request_params) { { 'player' => { name: "John", auth0_id: 'auth0|432212', ranking: 1, profile_picture_url: 'https://pool-app-storage.s3.us-east-2.amazonaws.com/foto_de_perfil.jpg' } } }
        run_test!
      end

      response '400', 'Bad request.' do
        let(:request_params) { { 'match' => { player1_id: 'foo' } } }
        run_test!
      end
    end
    get 'List all players (only admin users).' do
      tags 'Players'
      consumes 'application/json'
      security [ bearer: [] ]

      parameter name: 'name', in: :query, description: 'Filter by name'


      response '200', 'Returned players successfully.' do
        schema allOf: [ { '$ref' => '#/components/schemas/player' } ]
        let(:request_params) { { 'player' => { name: "John", auth0_id: 'auth0|432212', ranking: 1, profile_picture_url: 'https://pool-app-storage.s3.us-east-2.amazonaws.com/foto_de_perfil.jpg' } } }
        run_test!
      end

      response '400', 'Bad request.' do
        run_test!
      end
    end
  end
  path '/players/me' do
    patch 'Updates a player partially' do
      tags 'Players'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :name, in: :form, type: :string, description: 'Player name'
      parameter name: :profile_picture, in: :form, type: :file, description: 'Profile picture file'

      security [ bearer: [] ]

      response '200', 'Player updated successfully.' do
        let(:id) { create(:player).id }
        let(:name) { 'Updated Name' }
        let(:profile_picture) { fixture_file_upload(Rails.root.join('spec/fixtures/files/avatar.jpg'), 'image/jpeg') }

        schema '$ref' => '#/components/schemas/player'
        run_test!
      end

      response '404', 'Player not found.' do
        let(:id) { -1 }
        run_test!
      end
    end
    put 'Updates a player' do
      tags 'Players'
      consumes 'multipart/form-data'
      produces 'application/json'
      parameter name: :name, in: :form, type: :string, description: 'Player name'
      parameter name: :profile_picture, in: :form, type: :file, description: 'Profile picture file'

      security [ bearer: [] ]

      response '200', 'Player updated successfully.' do
        schema '$ref' => '#/components/schemas/player'
        run_test!
      end

      response '404', 'Player not found.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end
    end
    get 'Retrieves player information.' do
      tags 'Players'
      produces 'application/json'
      security [ bearer: [] ]

      response '200', 'Player retrieved successfully.' do
        schema '$ref' => '#/components/schemas/player'
        run_test!
      end
    end
  end
  path '/players/{:id}' do
    delete 'Destroys a player ' do
      tags 'Players'
      produces 'application/json'
      parameter name: 'id', in: :path, type: :integer, description: 'Match ID'
      security [ bearer: [] ]

      response '200', 'Player deleted successfully.' do
        schema '$ref' => '#/components/schemas/match'
        run_test!
      end

      response '404', 'Player not found.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end
    end
  end
end
