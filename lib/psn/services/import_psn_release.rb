# frozen_string_literal: true

module PSN
  module Services
    class ImportPSNRelease
      class << self
        def import(name, detail, communication_id, service, platforms)
          game = Game.create(name:)

          trophy_list = PSN::Services::ImportTitleTrophyList.import(name,
                                                                    detail,
                                                                    communication_id,
                                                                    service)

          create_releases(game, trophy_list, platforms)
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
