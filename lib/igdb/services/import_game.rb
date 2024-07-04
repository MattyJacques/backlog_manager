# frozen_string_literal: true

module IGDB
  module Services
    class ImportGame
      class << self
        delegate :import, to: :new
      end

      def import(igdb_id)
        Rails.logger.info("Importing game with IGDB ID: #{igdb_id}")

        igdb_data = get_igdb_data(igdb_id)

        game = Game.find_or_initialize_by(igdb_id: igdb_data['id'])

        import_game(game, igdb_data)

        game.save!

        Rails.logger.info("Updated game: #{game.name} (#{game.igdb_id})")

        game
      end

      private

      def import_game(game, igdb_data)
        game.name = igdb_data['name']
        game.genres = get_genres(igdb_data['genres'])

        platforms = get_platforms(igdb_data['platforms'])
        game.releases = import_releases(game, platforms, igdb_data['release_dates'])
      end

      def get_genres(genres)
        genres&.map do |genre|
          Rails.logger.info("Genre found: #{genre}")

          Genre.find_or_create_by!(igdb_id: genre)
        end
      end

      def get_platforms(platforms)
        platforms&.map do |platform|
          Rails.logger.info("Platform found: #{platform['id']}")

          Platform.find_or_create_by!(igdb_id: platform['id'])
        end
      end

      def import_releases(game, platforms, releases)
        releases&.map do |release|
          Rails.logger.info("Release found: #{release}")

          platform = platforms.detect { |plat| plat.igdb_id == release['platform'] }
          build_release(game, platform, release)
        end
      end

      def build_release(game, platform, release_data)
        Release.find_or_initialize_by(igdb_id: release_data['id']).tap do |r|
          r.date = release_data['date']
          r.region = release_data['region']
          r.platform = platform
          r.game = game
        end
      end

      def get_igdb_data(igdb_id)
        data = IGDB::Client::Games.get_by_id(igdb_id)

        raise "Game with IGDB ID #{igdb_id} not found" if data.blank?

        data
      end
    end
  end
end
