# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game do
  subject(:game) { build(:game) }

  it { is_expected.to have_many(:releases).dependent(:destroy).autosave(true) }
  it { is_expected.to have_many(:platforms).through(:releases).autosave(true) }
  it { is_expected.to have_and_belong_to_many(:genres) }

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
end
