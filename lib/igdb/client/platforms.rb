# frozen_string_literal: true

module IGDB
  module Client
    class Platforms < Base::Client
      ENDPOINT = 'platforms'

      class << self
        # Get the IGDB platform by the IGDB ID
        def get_by_id(igdb_id)
          raise 'IGDB ID should not be blank' if igdb_id.blank?

          params = import_param_fields
          params[:where] = "id = #{igdb_id}"

          post(ENDPOINT, params).first
        end

        private

        def import_param_fields
          {
            fields: 'name, abbreviation, slug, platform_family.name, platform_family.slug'
          }
        end
      end
    end
  end
end
