# frozen_string_literal: true

module PSN
  module Client
    class Auth
      AUTH_URL = 'https://ca.account.sony.com/api/authz/v3/'
      BASIC_TOKEN = ENV.fetch('PSN_BASIC_TOKEN', nil)

      class << self
        delegate :authenticate, to: :new
      end

      def authenticate
        Rails.logger.info('Getting new PSN access token')

        code = fetch_auth_code
        Rails.logger.debug { "Fetched authorisation code: #{code}" }

        access_token = fetch_token(code)
        Rails.logger.debug { "Fetched access token which expires in: #{access_token.expires_in / 60} minutes" }
        Rails.logger.info('Acquired new PSN access token')

        access_token.token
      end

      private

      def fetch_auth_code
        response = HTTParty.get(auth_url,
                                headers: { 'Cookie' => npsso_cookie },
                                follow_redirects: false)

        if response.headers['location'].blank?
          error_message = 'Failed to fetch PSN auth code, location header missing'
          Rails.logger.error(error_message)
          raise error_message
        end

        parse_code(response.headers['location'])
      end

      def fetch_token(code)
        client.auth_code.get_token(code,
                                   redirect_uri: 'com.scee.psxandroid.scecompcall://redirect',
                                   token_format: 'jwt',
                                   headers: { Authorization: "Basic #{BASIC_TOKEN}" })
      end

      def client
        @client ||= OAuth2::Client.new(ENV.fetch('PSN_CLIENT_ID', nil), '', site: AUTH_URL)
      end

      def auth_url
        client.auth_code.authorize_url(access_type: 'offline',
                                       redirect_uri: 'com.scee.psxandroid.scecompcall://redirect',
                                       scope: 'psn:mobile.v2.core psn:clientapp')
      end

      def parse_code(location)
        code = location.match(%r{\?code=([A-Za-z0-9:?_\-./=]+)})

        if code.present?
          code[1]
        else
          error = location.match(%r{&error=([A-Za-z0-9:?_\-./=]+)})

          message = get_error_message(error[1])
          Rails.logger.error(message)
          raise message
        end
      end

      def get_error_message(error)
        if error == 'login_required'
          'PSN authorisation failed, NPSSO code has expired'
        else
          "Unhandled PSN auth error (#{error})"
        end
      end

      def npsso_cookie
        "npsso=#{ENV.fetch('PSN_NPSSO', nil)}"
      end
    end
  end
end
