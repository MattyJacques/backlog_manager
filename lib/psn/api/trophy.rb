# frozen_string_literal: true

module PSN
  module API
    class Trophy
      BASE_PATH = 'https://ps5.np.playstation.net/api'
      NP_SERVICE_NAMES = %w[trophy trophy2].freeze
      TROPHY_GROUPS = %w[all default 001 002].freeze
      TITLES_LIMIT = 800

      class << self
        # Get the trophy summary for the given account
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=trophy-profile-summary
        #
        # accountId [String] PSN account ID, use 'me' for authenticating account
        def account_summary(account_id)
          raise 'account_id must be present' if account_id.blank?

          get("/trophy/v1/users/#{account_id}/trophySummary")
        end

        # Get synced trophy titles for the given account, can provided title IDs to get summaries of specified titles
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=_2-retrieve-the-trophies-for-a-title
        #
        # offset [Integer] { min: 0, max: totalItemCount - 1 }
        # limit [Integer] { min: 1, max: 800 }
        def account_titles(account_id, offset: 0, limit: 800)
          raise 'account_id must be present' if account_id.blank?
          raise 'limit must be less than or equal to 800' if limit > TITLES_LIMIT

          get("/trophy/v1/users/#{account_id}/trophyTitles", query: { offset:, limit: })
        end

        # Get the trophy list for the title with the given communication ID, can get trophy list for specific
        # trophy group.
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=_2-retrieve-the-trophies-for-a-title
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=_3-retrieve-trophies-earned-for-a-title
        #
        # communication_id [String] Communication ID of title
        # service_name [String] { 'trophy2' for PS5 or 'trophy' for PS3, PS4 and PS Vita }
        # account_id [String/Integer] Account ID for earned status, use nil for general
        # group_id [String] { 'all' || 'default' || '001' || '002' }
        def title_trophy_list(communication_id, service_name = 'trophy', account_id = nil, group_id = 'all')
          raise 'communication_id must be present' if communication_id.blank?
          raise 'service must be \'trophy\' or \'trophy2\'' unless NP_SERVICE_NAMES.include?(service_name)
          raise 'group id must be \'all\' or \'default\' or \'001\' or \'002\'' unless TROPHY_GROUPS.include?(group_id)

          get("/trophy/v1/#{account_path(account_id)}" \
              "npCommunicationIds/#{communication_id}/trophyGroups/#{group_id}/trophies",
              query: {
                npServiceName: service_name
              })
        end

        # Get a trophy summary for the given titles
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=trophy-title-summary-for-specific-title-id
        #
        # title_ids [Array[String]] ['CUSA09171', 'PPSA01284_00', 'PPSA04874_00']
        def account_summary_for_title(account_id, title_ids)
          raise 'account_id must be present' if account_id.blank?
          raise 'title_ids size must be less than or equal to 5' unless title_ids.length.between?(1, 5)

          get("/trophy/v1/users/#{account_id}/titles/trophyTitles",
              query: {
                npTitleIds: title_ids.join(',')
              })
        end

        # Get the data for a specific trophy, can be earned status or general
        #
        # communication_id [String] Communication ID of the title
        # trophy_id [Integer] ID of the trophy within the title trophy list
        # service_name [String] { 'trophy2' for PS5 or 'trophy' for PS3, PS4 and PS Vita }
        # account_id [String/Integer] Account ID for earned status, use nil for general
        def trophy(communication_id, trophy_id, service_name = 'trophy', account_id = nil)
          raise 'service_name should be \'trophy\' or \'trophy2\'' unless NP_SERVICE_NAMES.include?(service_name)

          get("/trophy/v1/#{account_path(account_id)}npCommunicationIds/#{communication_id}/trophies/#{trophy_id}",
              query: {
                npServiceName: service_name
              })
        end

        # Get data on the trophy groups (main list and DLCs etc) for a title.
        # https://andshrew.github.io/PlayStation-Trophies/#/APIv2?id=title-trophy-groups
        #
        # communication_id [String] Communication ID of the title
        # service_name [String] { 'trophy2' for PS5 or 'trophy' for PS3, PS4 and PS Vita }
        # account_id [String/Integer] Account ID for earned status, use nil for general
        def trophy_groups(communication_id, service_name = 'trophy', account_id = nil)
          raise 'service_name should be \'trophy\' or \'trophy2\'' unless NP_SERVICE_NAMES.include?(service_name)

          get("/trophy/v1/#{account_path(account_id)}npCommunicationIds/#{communication_id}/trophyGroups",
              query: {
                npServiceName: service_name
              })
        end

        private

        def get(path, options = {})
          PSN::API::Client.get(BASE_PATH + path, options)
        end

        def account_path(account_id)
          "users/#{account_id}/" if account_id
        end
      end
    end
  end
end
