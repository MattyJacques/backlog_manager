# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre do
  it { is_expected.to have_and_belong_to_many(:games) }

  describe '#import_igdb_genre' do
    subject(:genre) { described_class.new(igdb_id:) }

    let(:igdb_id) { 7 }

    it 'queues the import genre from IGDB job' do
      expect(IGDB::ImportGenreJob).to receive(:perform_later).with(igdb_id)

      genre.save!
    end
  end
end
