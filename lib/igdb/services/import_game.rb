# frozen_string_literal: true

module IGDB
  module Services
    class ImportGame
      class << self
        def import(title, platform = nil)
          title = title.gsub(Regexp.union('®', '™', ' Trophies'), '')
          result = IGDB::Client::Games.search(title, platform, full_data: true, limit: 1)

          raise 'No search results from IGDB' if result.blank?

          import_from_data(result.first)
        end

        private

        def import_from_data(igdb_data)
          raise 'Game already exists' if Game.exists?(igdb_id: igdb_data['id'])

          platforms = import_platforms(igdb_data['platforms'])

          game = Game.new(name: igdb_data['name'], igdb_id: igdb_data['id'])
          game.genres = import_genres(igdb_data['genres'])
          game.releases = import_releases(game, platforms, igdb_data['release_dates'])
          game.save!

          game
        end

        def import_genres(genres)
          return [] if genres.blank?

          genres.map { |genre| Genre.find_or_initialize_by(igdb_id: genre['id']) }
        end

        def import_platforms(platforms)
          return [] if platforms.blank?

          platforms.uniq.map do |platform|
            Platform.find_or_create_by!(igdb_id: platform['id'])
          end
        end

        def import_platform_family(family_data)
          return nil if family_data.blank?

          PlatformFamily.find_or_create_by!(igdb_id: family_data['id'], name: family_data['name'])
        end

        def import_releases(game, platforms, dates)
          return [] if dates.blank?

          dates.map do |date|
            platform = platforms.find { |plat| plat.igdb_id == date['platform'] }
            Release.new(game:, platform:, region: date['region'], date: seconds_to_date(date['date']))
          end
        end

        def seconds_to_date(timestamp)
          timestamp = 0 if timestamp.blank?

          time = Time.at(timestamp).utc
          Date.new(time.year, time.month, time.day)
        end
      end
    end
  end
end
