# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IGDB::ImportGenreJob do
  describe '#perform' do
    let(:igdb_id) { 11 }

    it 'calls the import genre service' do
      expect(IGDB::Services::ImportGenre).to receive(:import).with(igdb_id)

      subject.perform(igdb_id)
    end
  end
end
