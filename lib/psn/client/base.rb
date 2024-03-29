# frozen_string_literal: true

module PSN
  module Client
    # Handle sending requests to the PSN API
    class Base
      class << self
        def get(path, options = {})
          Rails.logger.info("Sending request to PSN: #{path}, options: #{options}")

          do_get_request(path, options)
        end

        private

        def do_get_request(path, options = {})
          with_retry_on_auth_error do
            HTTParty.get(path, headers: { 'Authorization' => "Bearer #{token}" }, **options, verify: false)
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
            PSN::Client::Auth.new.authenticate
          end
        end
      end
    end
  end
end
