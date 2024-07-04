# frozen_string_literal: true

module IGDB
  module Client
    module Base
      class Client
        URL = 'https://api.igdb.com/v4/'
        CLIENT_ID = ENV.fetch('IGDB_CLIENT_ID', nil)

        class << self
          def post(endpoint, params = { fields: '*' })
            uri = URI.parse(URL + endpoint)
            response = do_post_request(uri, params)

            handle_response(response)
          end

          private

          def do_post_request(uri, params)
            with_retry_on_auth_error do
              HTTParty.post(uri,
                            headers: { 'Client-ID' => CLIENT_ID,
                                       'Authorization' => "Bearer #{token}" },
                            body: convert_post_body(params))
            end
          end

          def handle_response(response)
            raise IGDB::Client::Errors::NotFound if response.blank?

            response
          end

          def with_retry_on_auth_error
            response = yield

            if response.code.to_i == 401
              # Clear the expired token
              Rails.cache.delete('igdb_token')

              response = yield
            end

            response
          end

          def convert_post_body(params)
            params.map { |key, value| "#{key} #{value};" }.join
          end

          def token
            # IGDB token seems to last just over 64 days
            Rails.cache.fetch('igdb_token', expires_in: 64.days) do
              IGDB::Client::Base::Auth.authenticate
            end
          end
        end
      end
    end
  end
end
