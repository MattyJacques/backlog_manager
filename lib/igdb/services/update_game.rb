# frozen_string_literal: true

module IGDB
  module Services
    class UpdateGame
      class << self
        delegate :update, to: :new
      end

      def update(igdb_id)
        Rails.logger.info("Importing game with IGDB ID: #{igdb_id}")

        update_game(get_igdb_data(igdb_id))

        Rails.logger.info("Imported game with IGDB ID: #{igdb_id}")
      end

      private

      def update_game(igdb_data)
        game = Game.find_or_initialize_by(igdb_id: igdb_data['id'])

        game.name = igdb_data['name']
        game.genres = update_genres(igdb_data['genres'])
        game.platforms = update_platforms(igdb_data['platforms'])
        game.save!
      end

      def update_genres(genres)
        genres&.map { |genre| Genre.find_or_create_by(igdb_id: genre['id']) }
      end

      def update_platforms(platforms)
        platforms&.map { |platform| Platform.find_or_create_by(igdb_id: platform['id']) }
      end

      def update_releases(releases)
        releases&.map do |release|
          Release.find_or_initialize_by(igdb_id: release['id']).tap do |r|
            r.date = release['date']
            r.region = release['region']
            r.platform = Platform.find_by(igdb_id: release['platform'])
          end
        end
      end

      def get_igdb_data(igdb_id)
        IGDB::Client::Games.get_by_id(igdb_id)
      end
    end
  end
end
