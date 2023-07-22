# frozen_string_literal: true

module PSN
  module Services
    class ImportPSNRelease
      class << self
        def import(psn_title_data)
          game = Game.create(name: psn_title_data['trophyTitleName'])

          trophy_list = PSN::Services::ImportTitleTrophyList.import(psn_title_data['trophyTitleName'],
                                                                    psn_title_data['trophyTitleDetail'],
                                                                    psn_title_data['npCommunicationId'],
                                                                    psn_title_data['npServiceName'],
                                                                    psn_title_data['trophyTitleIconUrl'])

          create_releases(game, trophy_list, psn_title_data['trophyTitlePlatform'])
        end

        private

        def create_releases(game, trophy_list, psn_platforms)
          psn_platforms.split(',').map do |platform|
            Release.create(game:,
                           platform: Platform.find_by!(abbreviation: platform),
                           trophy_list:)
          end
        end
      end
    end
  end
end
