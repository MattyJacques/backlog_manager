# frozen_string_literal: true

module PSN
  module Services
    class ImportTitleTrophyList
      class << self
        def import(name, detail, communication_id, service)
          Rails.logger.info("Importing #{name} with npCommID #{communication_id}, using #{service} service")

          psn_trophies = PSN::Client::Trophy.title_trophy_list(communication_id, service)

          trophy_list = TrophyList.create(name:,
                                          detail:,
                                          communication_id:,
                                          service:,
                                          version: psn_trophies['trophySetVersion'])

          psn_trophies['trophies'].each { |psn_trophy| create_trophy(trophy_list, psn_trophy) }

          Rails.logger.info("Imported #{psn_trophies['trophies'].count} trophies for #{name}")

          trophy_list
        end

        private

        def create_trophy(trophy_list, psn_trophy)
          Rails.logger.debug { "Create trophy #{psn_trophy['trophyId']} #{psn_trophy['trophyName']}" }

          Trophy.create(trophy_list:,
                        psn_id: psn_trophy['trophyId'],
                        name: psn_trophy['trophyName'],
                        detail: psn_trophy['trophyDetail'],
                        icon_url: psn_trophy['trophyIconUrl'],
                        rank: Trophy.ranks[psn_trophy['trophyType']],
                        hidden: psn_trophy['trophyHidden'],
                        progress_target: psn_trophy['trophyProgressTargetValue'],
                        trophy_group: psn_trophy['trophyGroupId'],
                        reward_name: psn_trophy['trophyRewardName'],
                        reward_url: psn_trophy['trophyRewardImageUrl'])
        end
      end
    end
  end
end
