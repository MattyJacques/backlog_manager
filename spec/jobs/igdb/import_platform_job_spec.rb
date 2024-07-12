# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::ImportPlatformJob do
  subject(:import_platform) { described_class.new }

  describe '#perform' do
    let(:igdb_id) { 7 }

    it 'calls the import platform service' do
      expect(IGDB::Services::ImportPlatform).to receive(:import).with(igdb_id)

      import_platform.perform(igdb_id)
    end
  end
end
