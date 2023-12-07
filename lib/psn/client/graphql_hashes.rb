# frozen_string_literal: true

module PSN
  module Client
    class GraphqlHashes
      # query getUserGameList($categories: String,
      #                       $limit: Int,
      #                       $orderBy: String,
      #                       $subscriptionService: SubscriptionService)
      # {
      #   gameLibraryTitlesRetrieve(categories: $categories,
      #                             limit: $limit,
      #                             orderBy: $orderBy,
      #                             subscriptionService: $subscriptionService)
      #   {
      #     __typename
      #     games
      #     {
      #       __typename
      #       conceptId
      #       entitlementId
      #       image { __typename url }
      #       isActive
      #       lastPlayedDateTime
      #       name
      #       platform
      #       productId
      #       subscriptionService
      #       titleId
      #     }
      #   }
      # }
      USER_RECENTLY_PLAYED = 'e0136f81d7d1fb6be58238c574e9a46e1c0cc2f7f6977a08a5a46f224523a004'

      # query getPurchasedGameList($isActive: Boolean,
      #                            $platform: [String],
      #                            $size: Int,
      #                            $start: Int,
      #                            $sortBy: String,
      #                            $sortDirection: String)
      # {
      #   purchasedTitlesRetrieve(isActive: $isActive,
      #                           platform: $platform,
      #                           size: $size,
      #                           start: $start,
      #                           sortBy: $sortBy,
      #                           sortDirection: $sortDirection)
      #   {
      #     __typename
      #     games
      #     {
      #       __typename
      #       conceptId
      #       entitlementId
      #       image { __typename url }
      #       isActive
      #       isDownloadable
      #       isPreOrder
      #       membership
      #       name
      #       platform
      #       productId
      #       titleId
      #     }
      #   }
      # }
      USER_PURCHASES = '827a423f6a8ddca4107ac01395af2ec0eafd8396fc7fa204aaf9b7ed2eefa168'
    end
  end
end
