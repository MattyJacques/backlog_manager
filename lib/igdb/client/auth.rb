# frozen_string_literal: true

module IGDB
  module Client
    class Auth
      AUTH_URL = 'https://id.twitch.tv'

      class << self
        delegate :authenticate, to: :new
      end

      def authenticate
        Rails.logger.info('Getting new IGDB access token')

        client.client_credentials.get_token.token
      end

      private

      def client
        @client ||= OAuth2::Client.new(ENV.fetch('IGDB_CLIENT_ID', nil),
                                       ENV.fetch('IGDB_CLIENT_SECRET', nil),
                                       site: AUTH_URL,
                                       token_url: 'oauth2/token',
                                       auth_scheme: :request_body)
      end
    end
  end
end
