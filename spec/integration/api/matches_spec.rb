require 'swagger_helper'

RSpec.describe 'api/matches', type: :request do
  path '/matches' do
    post 'Creates new match.' do
      tags 'Matches'
      consumes 'application/json'
      security [ bearer: [] ]
      parameter name: 'new_match', in: :body, schema: { '$ref' => '#/components/schemas/new_match' }
      request_body_example value: { player1_id: 1, player2_id: 2, start_time: DateTime.new().to_s, table_number: 1 }, name: 'basic', summary: 'Request example description'

      response '201', 'Match created successfully.' do
        schema '$ref' => '#/components/schemas/match'
        let(:request_params) { { 'match' => { player1_id: 1, player2_id: 2, table_number: 1, start_time: DateTime.new() } } }
        run_test!
      end

      response '400', 'Bad request.' do
        let(:request_params) { { 'match' => { player1_id: 'foo' } } }
        run_test!
      end
    end
    get 'List all matches.' do
      tags 'Matches'
      consumes 'application/json'
      security [ bearer: [] ]

      parameter name: 'status', in: :query,
          enum: { 'ongoing': 'Retrieves ongoing matches.', 'completed': 'Retrieves completed matches.', 'upcoming': 'Retrieves upcoming matches.' },
          description: 'Filter by status'


      response '200', 'Returned matches successfully.' do
        schema allOf: [ { '$ref' => '#/components/schemas/match' } ]
        let(:request_params) { { 'match' => { player1_id: 1, player2_id: 2, table_number: 1, start_time: 'bar' } } }
        run_test!
      end

      response '400', 'Bad request.' do
        let(:request_params) { { 'match' => { player1_id: 'foo' } } }
        run_test!
      end
    end
  end
  path '/matches/{id}' do
    get 'Retrieves a match' do
      tags 'Matches'
      produces 'application/json'
      parameter name: 'id', in: :path, type: :integer, description: 'Match ID'
      security [ bearer: [] ]

      response '200', 'Match found.' do
        schema '$ref' => '#/components/schemas/match'
        # let(:request_params) { 'id' => { Match.create(title: 'foo', content: 'bar').id } }
        run_test!
      end

      response '404', 'Match not found.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end
    end
    patch 'Updates a match partially' do
      tags 'Matches'
      produces 'application/json'
      parameter name: 'id', in: :path, type: :integer, description: 'Match ID'
      security [ bearer: [] ]

      response '200', 'Match updated successfully.' do
        schema '$ref' => '#/components/schemas/match'
        # let(:request_params) { 'id' => { Match.create(title: 'foo', content: 'bar').id } }
        run_test!
      end

      response '404', 'Match not found.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end

      response '409', 'Double booking detected.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end
    end
    put 'Updates a match' do
      tags 'Matches'
      produces 'application/json'
      parameter name: 'id', in: :path, type: :integer, description: 'Match ID'
      security [ bearer: [] ]

      response '200', 'Match updated successfully.' do
        schema '$ref' => '#/components/schemas/match'
        # let(:request_params) { 'id' => { Match.create(title: 'foo', content: 'bar').id } }
        run_test!
      end

      response '404', 'Match not found.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end

      response '409', 'Double booking detected.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end
    end
    delete 'Destroys a match ' do
      tags 'Matches'
      produces 'application/json'
      parameter name: 'id', in: :path, type: :integer, description: 'Match ID'
      security [ bearer: [] ]

      response '200', 'Match deleted successfully.' do
        schema '$ref' => '#/components/schemas/match'
        # let(:request_params) { 'id' => { Match.create(title: 'foo', content: 'bar').id } }
        run_test!
      end

      response '404', 'Match not found.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end

      response '409', 'Ongoing match cannot deleted.' do
        let(:request_params) { { 'id' => 'invalid' } }
        run_test!
      end
    end
  end
end
