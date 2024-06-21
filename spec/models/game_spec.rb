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
end
