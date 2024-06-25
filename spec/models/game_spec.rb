# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Game do
  subject(:game) { build(:game) }

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
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:igdb_id) }
  end
end
