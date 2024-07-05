# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Genre do
  subject(:genre) { build(:genre) }

  it { is_expected.to have_and_belong_to_many(:games) }

  describe 'validations' do
    before do
      described_class.skip_callback(:create, :after, :import_igdb_data)
    end

    after do
      described_class.set_callback(:create, :after, :import_igdb_data)
    end

    context 'when validating presence' do
      it { is_expected.to validate_presence_of(:igdb_id) }
    end

    context 'when validating numericality' do
      it { is_expected.to validate_numericality_of(:igdb_id) }
    end

    context 'when validating uniqueness' do
      it { is_expected.to validate_uniqueness_of(:name).case_insensitive.allow_nil }
      it { is_expected.to validate_uniqueness_of(:slug).case_insensitive.allow_nil }
      it { is_expected.to validate_uniqueness_of(:igdb_id) }
    end
  end

  describe '#import_igdb_data' do
    subject(:genre) { described_class.new(igdb_id:) }

    let(:igdb_id) { 7 }

    it 'queues the import genre from IGDB job' do
      expect(IGDB::Services::ImportGenre).to receive(:import).with(igdb_id)

      genre.run_callbacks(:create)
    end
  end
end
