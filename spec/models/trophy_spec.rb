# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Trophy do
  subject(:trophy) do
    described_class.new(psn_id: 0,
                        name: 'So Shiny',
                        detail: 'Earn it',
                        icon_url: 'image.com/trophy',
                        rank: 0,
                        trophy_list:)
  end

  let(:trophy_list) { TrophyList.new(communication_id: 'NPWR12345_00', service: 'trophy2') }

  it { is_expected.to belong_to(:trophy_list) }
  it { is_expected.to have_many(:earned_trophies).dependent(:destroy) }
  it { is_expected.to have_many(:psn_accounts).through(:earned_trophies) }

  it do
    expect(trophy).to define_enum_for(:rank).with_values(
      { bronze: 0, silver: 1, gold: 2, platinum: 3 }
    )
  end

  context 'when validating presence' do
    it { is_expected.to validate_presence_of(:psn_id) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:detail) }
    it { is_expected.to validate_presence_of(:icon_url) }
    it { is_expected.to validate_presence_of(:rank) }
  end

  context 'when validating uniqueness' do
    it { is_expected.to validate_uniqueness_of(:psn_id).scoped_to(:trophy_list_id) }
  end
end
