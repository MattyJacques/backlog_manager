# frozen_string_literal: true

module PSN
  module API
    class User
      class << self
        # Get the profile of the user with the given PSN ID
        #
        # username [String] PSN ID
        def get_profile_from_username(username)
          raise 'PSN username must be present' if username.blank?

          PSN::API::Client.get("https://us-prof.np.community.playstation.net/userProfile/v1/users/#{username}/profile2?fields=npId,onlineId,accountId,avatarUrls,plus,aboutMe,languagesUsed,trophySummary(@default,level,progress,earnedTrophies),isOfficiallyVerified,personalDetail(@default,profilePictureUrls),personalDetailSharing,personalDetailSharingRequestMessageFlag,primaryOnlineStatus,presences(@default,@titleInfo,platform,lastOnlineDate,hasBroadcastData),requestMessageFlag,blocking,friendRelation,following,consoleAvailability")
        end

        # Get the profile of the user with the given Account ID.
        # Prefer not to use, use from get_profile_from_username for fuller profile
        #
        # account_id [String] PSN Account ID
        def get_profile_from_account_id(account_id)
          PSN::API::Client.get("https://m.np.playstation.com/api/userProfile/v1/internal/users/#{account_id}/profiles")
        end
      end
    end
  end
end
