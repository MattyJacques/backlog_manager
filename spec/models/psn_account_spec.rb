# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PSNAccount do
  subject(:account) { build(:psn_account) }

  it { is_expected.to have_many(:account_trophy_lists).dependent(:destroy) }
  it { is_expected.to have_many(:trophy_lists).through(:account_trophy_lists) }
  it { is_expected.to have_many(:earned_trophies).through(:account_trophy_lists) }
  it { is_expected.to have_many(:trophies).through(:earned_trophies) }

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:psn_id) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:psn_id).case_insensitive }
  end

  describe '#earned_trophy_count' do
    subject(:account) { build(:psn_account, earned_bronze:, earned_silver:, earned_gold:, earned_platinum:) }

    let(:earned_bronze) { 123 }
    let(:earned_silver) { 321 }
    let(:earned_gold) { 999 }
    let(:earned_platinum) { 12 }

    it 'returns the total earned trophy count' do
      expect(account.earned_trophy_count).to be(earned_bronze + earned_silver + earned_gold + earned_platinum)
    end
  end
end
