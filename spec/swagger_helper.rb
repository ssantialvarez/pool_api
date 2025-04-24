# frozen_string_literal: true

require 'rails_helper'

RSpec.configure do |config|
  # Specify a root folder where Swagger JSON files are generated
  # NOTE: If you're using the rswag-api to serve API descriptions, you'll need
  # to ensure that it's configured to serve Swagger from the same folder
  config.openapi_root = Rails.root.join('swagger').to_s

  # Define one or more Swagger documents and provide global metadata for each one
  # When you run the 'rswag:specs:swaggerize' rake task, the complete Swagger will
  # be generated at the provided relative path under openapi_root
  # By default, the operations defined in spec files are added to the first
  # document below. You can override this behavior by adding a openapi_spec tag to the
  # the root example_group in your specs, e.g. describe '...', openapi_spec: 'v2/swagger.json'
  config.openapi_specs = {
    'v1/swagger.yaml' => {
      openapi: '3.0.1',
      info: {
        title: 'API V1',
        version: 'v1'
      },
      paths: {},
      servers: [
        {
          url: 'http://localhost:3000',
          description: 'Local server'
        }
      ],
      components: {
        securitySchemes: {
          bearer: {
            type: :http,
            scheme: :bearer,
            bearerFormat: JWT
          }
        },
        schemas: {
          match: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              player1_id: { type: 'integer' },
              player2_id: { type: 'integer' },
              start_time: { type: 'string', format: 'date-time' },
              end_time: { type: 'string', format: 'date-time', nullable: true },
              winner_id: { type: 'string', nullable: true },
              table_number: { type: 'integer', nullable: true },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            }
          },
          player: {
            type: 'object',
            properties: {
              id: { type: 'integer' },
              auth0_id: { type: 'string' },
              name: { type: 'string' },
              ranking: { type: 'integer' },
              profile_picture_url: { type: 'string', format: 'uri' },
              created_at: { type: 'string', format: 'date-time' },
              updated_at: { type: 'string', format: 'date-time' }
            }
          },
          new_match: {
            type: 'object',
            properties: {
              player1_id: { type: 'integer' },
              player2_id: { type: 'integer' },
              start_time: { type: 'string', format: 'date-time' },
              table_number: { type: 'integer', nullable: true }
            },
            required: %w[player1_id player2_id start_time]
          },
          new_player: {
            type: 'object',
            properties: {
              auth0_id: { type: 'string' },
              name: { type: 'string' },
              ranking: { type: 'integer', nullable: true },
              profile_picture_url: { type: 'string', format: 'uri' }
            },
            required: %w[name profile_picture_url auth0_id]
          }
        }
      }
    }
  }

  # Specify the format of the output Swagger file when running 'rswag:specs:swaggerize'.
  # The openapi_specs configuration option has the filename including format in
  # the key, this may want to be changed to avoid putting yaml in json files.
  # Defaults to json. Accepts ':json' and ':yaml'.
  config.openapi_format = :yaml
end
