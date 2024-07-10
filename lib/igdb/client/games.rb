# frozen_string_literal: true

module IGDB
  module Client
    class Games < Base::Client
      ENDPOINT = 'games'

      class << self
        # Search IGDB for a game with the given name
        def search(name, limit: 20)
          raise 'Search query should not be blank' if name.blank?

          Rails.logger.info("Searching IGDB for #{name}")

          params = search_param_fields
          params[:search] = "\"#{name}\""
          params[:where] = 'category = (0,8,9,10,11) & version_parent = null'
          params[:limit] = limit

          post(ENDPOINT, params)
        end

        def get_by_id(igdb_id)
          raise 'IGDB ID should not be blank' if igdb_id.blank?

          params = import_param_fields
          params[:where] = "id = #{igdb_id}"

          post(ENDPOINT, params).first
        end

        private

        def search_param_fields
          {
            fields: 'name, genres.name, platforms.name, platforms.platform_family.name'
          }
        end

        def import_param_fields
          {
            fields: 'name, genres, platforms, platforms.platform_family, release_dates.date, ' \
                    'release_dates.game, release_dates.platform, release_dates.region'
          }
        end
      end
    end
  end
end
