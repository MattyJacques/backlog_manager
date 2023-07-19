# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game do
  subject(:game) { described_class.new(name: 'The Last of Us') }

  it { is_expected.to have_many(:releases).dependent(:destroy) }
  it { is_expected.to have_many(:trophy_lists).through(:releases) }

  context 'when validating everything' do
    it 'is valid with valid attributes' do
      expect(game).to be_valid
    end
  end

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:name) }
  end

  context 'when validating numericality' do
    it { is_expected.to validate_numericality_of(:igdb_id).allow_nil }
    it { is_expected.to validate_numericality_of(:how_long_to_beat_id).allow_nil }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:igdb_id) }
    it { is_expected.to validate_uniqueness_of(:how_long_to_beat_id) }
  end
end
