# frozen_string_literal: true

module IGDB
  module Services
    class ImportPlatform
      class << self
        delegate :import, to: :new
      end

      def import(igdb_id)
        result = IGDB::Client::Platforms.get_by_id(igdb_id)

        family = import_platform_family(result['platform_family'])
        import_platform(result, family)
      end

      private

      def import_platform_family(family_data)
        return nil if family_data.blank?

        PlatformFamily.find_or_create_by!(igdb_id: family_data['id'],
                                          name: family_data['name'],
                                          slug: family_data['slug'])
      end

      def import_platform(igdb_data, platform_family)
        platform = Platform.find_or_initialize_by(igdb_id: igdb_data['id'])
        platform.update!(name: igdb_data['name'],
                         abbreviation: igdb_data['abbreviation'],
                         slug: igdb_data['slug'],
                         platform_family:)
      end
    end
  end
end
