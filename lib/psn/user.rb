# frozen_string_literal: true

module PSN
  class User
    class << self
      # Get the profile of the user with the given PSN ID
      #
      # username [String] PSN ID
      def get_from_username(username)
        raise 'PSN username must be present' if username.blank?

        PSN::API::User.get_profile_from_username(username)
      end

      # Get the profile of the user with the given Account ID.
      # Prefer not to use, use from get_from_username for extensive profile
      #
      # account_id [String] PSN Account ID
      def get_from_account_id(account_id)
        raise 'account_id must be present' if account_id.blank?

        PSN::API::User.get_profile_from_account_id(account_id)
      end
    end
  end
end
