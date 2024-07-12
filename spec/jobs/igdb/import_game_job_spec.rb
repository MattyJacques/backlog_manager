# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::ImportGameJob do
  subject(:import_game) { described_class.new }

  describe '#perform' do
    let(:igdb_id) { 26192 }

    it 'calls the import genre service' do
      expect(IGDB::Services::ImportGame).to receive(:import).with(igdb_id)

      import_game.perform(igdb_id)
    end
  end
end
