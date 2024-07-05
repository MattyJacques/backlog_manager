# frozen_string_literal: true

module IGDB
  module Client
    class Genres < Base::Client
      ENDPOINT = 'genres'

      class << self
        # Get the IGDB genre by the IGDB ID
        def get_by_id(igdb_id)
          raise 'IGDB ID should not be blank' if igdb_id.blank?

          params = import_param_fields
          params[:where] = "id = #{igdb_id}"

          post(ENDPOINT, params).first
        end

        private

        def import_param_fields
          {
            fields: 'name, slug'
          }
        end
      end
    end
  end
end
