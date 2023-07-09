# frozen_string_literal: true

require 'httparty'

module PSN
  module API
    # Handle sending requests to the PSN API
    class Client
      class << self
        def get(path, options = {})
          Rails.logger.info("Sending request to PSN: #{path}, options: #{options}")

          do_get_request(path, options)
        end

        def post(path, body, options = {})
          Rails.logger.info("Sending request to PSN: #{path}, body: #{body}, options: #{options}")

          do_post_request(path, options)
        end

        private

        def do_get_request(path, options = {})
          with_retry_on_auth_error do
            HTTParty.get(path, headers: { 'Authorization' => "Bearer #{token}" }, **options, verify: false)
          end
        end

        def do_post_request(path, body, options = {})
          with_retry_on_auth_error do
            HTTParty.post(path,
                          headers: { 'Authorization' => "Bearer #{token}" },
                          body:,
                          **options,
                          verify: false)
          end
        end

        def with_retry_on_auth_error
          response = yield

          if response.code.to_i == 401
            # Clear the expired token
            Rails.cache.delete('psn_token')

            response = yield
          end

          Rails.logger.debug do
            "PSN response: #{response.to_s.encode('utf-8',
                                                  invalid: :replace,
                                                  undef: :replace,
                                                  replace: '_')}"
          end

          response
        end

        def token
          # PSN token lasts about an hour
          Rails.cache.fetch('psn_token', expires_in: 59.minutes) do
            PSN::API::Auth.new.authenticate
          end
        end
      end
    end
  end
end
