# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game do
  subject(:game) { build(:game) }

  it { is_expected.to have_many(:releases).dependent(:destroy).autosave(true) }
  it { is_expected.to have_many(:platforms).through(:releases).autosave(true) }
  it { is_expected.to have_one(:game_status).dependent(:destroy) }
  it { is_expected.to have_and_belong_to_many(:genres) }

  describe 'nested attributes' do
    describe 'game_status' do
      it { is_expected.to accept_nested_attributes_for(:game_status).allow_destroy(true) }

      context 'when game_status.status is blank' do
        it 'rejects the game_status' do
          game_attributes = attributes_for(:game, game_status_attributes: { status: nil })

          expect(described_class.build(game_attributes).game_status).to be_nil
        end
      end
    end
  end

  describe 'validations' do
    before do
      described_class.skip_callback(:create, :after, :import_igdb_data)
    end

    after do
      described_class.set_callback(:create, :after, :import_igdb_data)
    end

    context 'when validating everything' do
      it 'is valid with valid attributes' do
        expect(game).to be_valid
      end
    end

    context 'when validating presence' do
      context 'when igdb_id is not present' do
        before do
          game.igdb_id = nil
        end

        it { is_expected.to validate_presence_of(:name) }
      end

      context 'when igdb_id is present' do
        before do
          game.igdb_id = 1
        end

        it { is_expected.not_to validate_presence_of(:name) }
      end
    end

    context 'when validating numericality' do
      it { is_expected.to validate_numericality_of(:igdb_id).is_greater_than(0).allow_nil }
    end

    context 'when validating uniqueness' do
      it { is_expected.to validate_uniqueness_of(:igdb_id) }
    end
  end

  describe '#import_igdb_data' do
    subject(:only_igdb_game) { described_class.new(igdb_id:) }

    let(:igdb_id) { 26192 }

    it 'queues the import game from IGDB job' do
      only_igdb_game.run_callbacks(:create)

      expect(IGDB::ImportGameJob).to have_been_enqueued.with(igdb_id)
    end
  end
end
